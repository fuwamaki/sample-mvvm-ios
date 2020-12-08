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
    func handleLineLoginWithSuccess(lineUser: LineUser)
    func handleLineLoginWithError(error: LineSDKError)
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
        let user = UserDefaultsRepository.shared.fetchUser() ?? nil
        self.user.accept(user)
        isSignedIn.accept(user != nil)
    }

    private func accountExists(userType: UserType, userId: String, completion: @escaping (Result<UserRealmEntity?, NSError>) -> Void) {
        UserRealmRepository<UserRealmEntity>.find(userType: userType, userId: userId) { result in
            switch result {
            case .success(let userEntity):
                completion(.success(userEntity))
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

    func handleEditButton() {
        guard let user = user.value else {
            presentScreenSubject.accept(
                .errorAlert(message: R.string.localizable.error_login()))
            return
        }
        pushScreenSubject.accept(.updateUser(user: user))
    }

    // MARK: LINE
    func handleLineLoginWithSuccess(lineUser: LineUser) {
        accountExists(userType: .line, userId: lineUser.userId) { [weak self] result in
            switch result {
            case .success(.some(let userEntity)):
                let user = User(userType: UserType(rawValue: userEntity.userType)!,
                                token: lineUser.token,
                                userId: userEntity.userId,
                                name: userEntity.name,
                                birthday: userEntity.birthday,
                                iconImage: userEntity.iconImageData)
                UserDefaultsRepository.shared.createUser(user: user)
                self?.checkUser()
                self?.completedSubject.accept(true)
            case .success(.none):
                self?.pushScreenSubject.accept(.createLineUser(lineUser))
            case .failure(let error):
                guard let error = error as? APIError else { return }
                self?.presentScreenSubject.accept(.errorAlert(message: error.message))
            }
        }
    }

    func handleLineLoginWithError(error: LineSDKError) {
        presentScreenSubject.accept(
            .errorAlert(message: error.errorDescription ?? R.string.localizable.error_unknown()))
    }

    // MARK: Apple
    func handleCompletedAppleSignin(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authCodeData = appleIDCredential.authorizationCode,
              let authCode = String(data: authCodeData, encoding: .utf8) else {
            presentScreenSubject.accept(.errorAlert(message: R.string.localizable.error_unknown()))
            return
        }
        let fullName = appleIDCredential.fullName
        let appleUser = AppleUser(token: authCode,
                                  userId: appleIDCredential.user,
                                  givenName: fullName?.givenName,
                                  familyName: fullName?.familyName)
        accountExists(userType: .apple, userId: appleUser.userId) { [weak self] result in
            switch result {
            case .success(.some(let userEntity)):
                let user = User(userType: UserType(rawValue: userEntity.userType)!,
                                token: appleUser.token,
                                userId: userEntity.userId,
                                name: userEntity.name,
                                birthday: userEntity.birthday,
                                iconImage: userEntity.iconImageData)
                UserDefaultsRepository.shared.createUser(user: user)
                self?.checkUser()
                self?.completedSubject.accept(true)
            case .success(.none):
                self?.pushScreenSubject.accept(
                    .createAppleUser(appleUser))
            case .failure(let error):
                guard let error = error as? APIError else { return }
                self?.presentScreenSubject.accept(
                    .errorAlert(message: error.message))
            }
        }
    }

    func handleFailureAppleSignin(_ error: Error) {
        presentScreenSubject.accept(
            .errorAlert(message: error.localizedDescription))
    }
}
