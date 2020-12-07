//
//  MypageViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa
import LineSDK
import AuthenticationServices

protocol MypageViewModelable {
    var viewWillAppear: PublishRelay<Void> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isSignedIn: BehaviorRelay<Bool> { get }
    var user: BehaviorRelay<User?> { get }
    var pushScreen: Driver<Screen> { get }
    var presentScreen: Driver<Screen> { get }
    var completedSubject: BehaviorRelay<Bool> { get }
    func handleSettingBarButtonItem()
    func handleLogoutInSettingBarButtonItem()
    func handleLineLoginButton(viewController: UIViewController) -> Completable
    func handleAppleSigninButton(viewController: MypageViewController)
    func handleCompletedAppleSignin(_ authorization: ASAuthorization)
    func handleFailureAppleSignin(_ error: Error)
    func handleEditButton()
}

final class MypageViewModel {

    private(set) var viewWillAppear = PublishRelay<Void>()
    private(set) var completedSubject = BehaviorRelay<Bool>(value: false)
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var isSignedIn = BehaviorRelay<Bool>(value: false)
    private(set) var user = BehaviorRelay<User?>(value: nil)

    private var pushScreenSubject = PublishRelay<Screen>()
    var pushScreen: Driver<Screen> {
        return pushScreenSubject.asDriver(onErrorJustReturn: .other)
    }

    private var presentScreenSubject = PublishRelay<Screen>()
    var presentScreen: Driver<Screen> {
        return presentScreenSubject.asDriver(onErrorJustReturn: .other)
    }

    private let disposeBag = DisposeBag()
    private let apiClient: APIClientable

    convenience init() {
        self.init(apiClient: APIClient())
    }

    init(apiClient: APIClientable) {
        self.apiClient = apiClient
        subscribe()
    }

    private func subscribe() {
        viewWillAppear
            .subscribe(onNext: { [unowned self] in
                self.checkUser()
            })
            .disposed(by: disposeBag)
    }

    private func checkUser() {
        if let lineAccessToken = UserDefaultsRepository.shared.lineAccessToken,
            let userId = UserDefaultsRepository.shared.userId,
            let name = UserDefaultsRepository.shared.name,
            let birthday = UserDefaultsRepository.shared.birthday {
            let user = User(token: lineAccessToken,
                            userId: userId,
                            name: name,
                            birthday: DateFormat.yyyyMMdd.date(from: birthday)!,
                            iconImageURL: UserDefaultsRepository.shared.pictureUrl,
                            iconImage: UserDefaultsRepository.shared.iconImage)
            self.user.accept(user)
            isSignedIn.accept(true)
        } else {
            user.accept(nil)
            isSignedIn.accept(false)
        }
    }

    private func accountExists(lineUser: LineUser, completion: @escaping (Result<Bool, NSError>) -> Void) {
        guard let userId = lineUser.userId else { return }
        UserRealmRepository<UserRealmEntity>.find(userId: userId) { result in
            switch result {
            case .success(let userEntity):
                if let userEntity = userEntity {
                    UserDefaultsRepository.shared.userId = userEntity.userId
                    UserDefaultsRepository.shared.lineAccessToken = lineUser.accessToken
                    UserDefaultsRepository.shared.name = userEntity.name
                    UserDefaultsRepository.shared.birthday = DateFormat.yyyyMMdd.string(from: userEntity.birthday)
                    if userEntity.iconImageUrl != "", let imageUrl = URL(string: userEntity.iconImageUrl) {
                        UserDefaultsRepository.shared.pictureUrl = imageUrl
                    }
                    UserDefaultsRepository.shared.iconImage = userEntity.iconImageData
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: MypageViewModelable
extension MypageViewModel: MypageViewModelable {
    func handleSettingBarButtonItem() {
        presentScreenSubject.accept(.mypageActionSheet)
    }

    func handleLogoutInSettingBarButtonItem() {
        UserDefaultsRepository.shared.removeUser()
        checkUser()
    }

    // TODO: 状態管理ベースでリファクタリング
    func handleLineLoginButton(viewController: UIViewController) -> Completable {
        return apiClient.lineLogin(viewController: viewController)
            .do(
                onSuccess: { [weak self] lineUser in
                    self?.accountExists(lineUser: lineUser, completion: { [weak self] result in
                        switch result {
                        case .success(let isSignedIn):
                            self?.isLoading.accept(false)
                            if isSignedIn {
                                self?.checkUser()
                                self?.completedSubject.accept(true)
                            } else {
                                self?.pushScreenSubject.accept(.createUser(lineUser: lineUser))
                            }
                        case .failure(let error):
                            guard let error = error as? APIError else { return }
                            self?.isLoading.accept(false)
                            self?.presentScreenSubject.accept(.errorAlert(message: error.message))
                        }
                    })
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.presentScreenSubject.accept(.errorAlert(message: error.message))
                })
            .map { _ in }
            .asCompletable()
    }

    func handleAppleSigninButton(viewController: MypageViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = viewController
        authorizationController.presentationContextProvider = viewController
        authorizationController.performRequests()
    }

    func handleCompletedAppleSignin(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let authCodeData = appleIDCredential.authorizationCode,
                let authCode = String(data: authCodeData, encoding: .utf8),
                let idTokenData = appleIDCredential.identityToken,
                let idToken = String(data: idTokenData, encoding: .utf8) else {
                    print("Problem with the authorizationCode")
                    return
            }
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName
            // TODO: 以下処理
            print("authorization code : \(authCode)")
            print("identity token : \(idToken)")
            print("email: \(String(describing: email))")
            print("full name : \(String(describing: fullName))")
            print("first name: \(String(describing: fullName?.givenName))")
            print("last name: \(String(describing: fullName?.familyName))")
        }
    }

    func handleFailureAppleSignin(_ error: Error) {
        presentScreenSubject.accept(.errorAlert(message: error.localizedDescription))
    }

    func handleEditButton() {
        guard let user = user.value else {
            presentScreenSubject.accept(.errorAlert(message: "ユーザ情報を正しく取得できません。再度ログインしてください。"))
            return
        }
        pushScreenSubject.accept(.updateUser(user: user))
    }
}
