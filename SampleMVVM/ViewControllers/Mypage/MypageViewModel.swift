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

protocol MypageViewModelable {
    var viewWillAppear: PublishRelay<Void> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isSignedIn: BehaviorRelay<Bool> { get }
    var user: BehaviorRelay<User?> { get }
    var pushViewController: Driver<UIViewController> { get }
    var presentViewController: Driver<UIViewController> { get }
    func handleLineLoginButton(viewController: UIViewController) -> Completable
    func handleEditButton()
}

final class MypageViewModel {

    var viewWillAppear = PublishRelay<Void>()
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSignedIn = BehaviorRelay<Bool>(value: false)
    var user = BehaviorRelay<User?>(value: nil)

    private var pushViewControllerSubject = PublishRelay<UIViewController>()
    var pushViewController: Driver<UIViewController> {
        return pushViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private var presentViewControllerSubject = PublishRelay<UIViewController>()
    var presentViewController: Driver<UIViewController> {
        return presentViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
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
                if let lineAccessToken = UserDefaultsRepository.shared.lineAccessToken,
                    let userId = UserDefaultsRepository.shared.userId,
                    let name = UserDefaultsRepository.shared.name,
                    let birthday = UserDefaultsRepository.shared.birthday {
                    let iconImageURL = UserDefaultsRepository.shared.pictureUrl
                    let user = User(lineAccessToken: lineAccessToken,
                                    userId: userId,
                                    name: name,
                                    birthday: DateFormat.yyyyMMdd.date(from: birthday)!,
                                    iconImageURL: iconImageURL)
                    self.user.accept(user)
                    self.isSignedIn.accept(true)
                } else {
                    self.user.accept(nil)
                    self.isSignedIn.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MypageViewModel: MypageViewModelable {
    func handleLineLoginButton(viewController: UIViewController) -> Completable {
        return apiClient.lineLogin(viewController: viewController)
            .do(
                onSuccess: { [weak self] lineUser in
                    self?.isLoading.accept(false)
                    let viewController = UserRegistrationViewController.make(type: .create(lineUser: lineUser))
                    self?.pushViewControllerSubject.accept(viewController)
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    let errorAlert = UIAlertController.singleErrorAlert(message: error.message)
                    self?.presentViewControllerSubject.accept(errorAlert) })
            .map { _ in }
            .asCompletable()
    }

    func handleEditButton() {
        guard let user = user.value else {
            let errorAlert = UIAlertController.singleErrorAlert(message: "ユーザ情報を正しく取得できません。再度ログインしてください。")
            presentViewControllerSubject.accept(errorAlert)
            return
        }
        let viewController = UserRegistrationViewController.make(type: .update(user: user))
        pushViewControllerSubject.accept(viewController)
    }
}
