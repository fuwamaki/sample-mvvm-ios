//
//  MypageViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import PINRemoteImage
import PKHUD
import AuthenticationServices
import LineSDK

final class MypageViewController: UIViewController {

    @IBOutlet private weak var settingBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var profileCardView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var loginStackView: UIStackView!
    @IBOutlet private weak var lineLoginButton: UIButton!
    @IBOutlet private weak var appleLoginDescriptionLabel: UILabel!
    @IBOutlet private weak var appleLoginButton: UIButton!

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = defaultIndicator
        indicator.center = view.center
        return indicator
    }()

    private var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.isLoading ? self.indicator.startAnimating() : self.indicator.stopAnimating()
                self.indicator.isHidden = !self.isLoading
            }
        }
    }

    private let disposeBag = DisposeBag()
    private let viewModel: MypageViewModelable = MypageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTexts()
        bind()
    }

    private func setupViews() {
        view.addSubview(indicator)
        profileCardView.layer.shadowColor = UIColor.tertiarySystemBackground.cgColor
        profileCardView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        profileCardView.layer.shadowOpacity = 0.8
        profileCardView.layer.masksToBounds = false
        iconImageView.layer.shadowColor = UIColor.label.cgColor
        iconImageView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        lineLoginButton.setTitle(R.string.localizable.mypage_line_login(), for: .normal)
    }

    private func setupTexts() {
        navigationItem.title = R.string.localizable.mypage_title()
        lineLoginButton.setTitle(R.string.localizable.mypage_line_login(), for: .normal)
        editButton.setTitle(R.string.localizable.mypage_edit(), for: .normal)
        appleLoginButton.setTitle(R.string.localizable.mypage_apple_login(), for: .normal)
        appleLoginDescriptionLabel.text = R.string.localizable.mypage_apple_login_description()
    }

    // swiftlint:disable function_body_length
    private func bind() {
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .subscribe(onNext: { [unowned self] in
                self.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.presentScreen
            .drive(onNext: { [unowned self] screen in
                switch screen {
                case .errorAlert(let message):
                    let alert = UIAlertController.singleErrorAlert(message: message)
                    self.present(alert, animated: true, completion: nil)
                case .mypageActionSheet:
                    let actionSheet = UIAlertController(
                        title: R.string.localizable.mypage_setting_menu_title(),
                        message: nil,
                        preferredStyle: .actionSheet)
                    actionSheet.addAction(
                        UIAlertAction(
                            title: R.string.localizable.mypage_setting_menu_logout(),
                            style: .destructive,
                            handler: { _ in
                                self.viewModel.handleLogoutInSettingBarButtonItem()
                            }))
                    actionSheet.addAction(
                        UIAlertAction(
                            title: R.string.localizable.mypage_setting_menu_cancel(),
                            style: .cancel,
                            handler: nil))
                    self.present(actionSheet, animated: true, completion: nil)
                default: break
                }
            })
            .disposed(by: disposeBag)

        viewModel.pushScreen
            .drive(onNext: { [unowned self] screen in
                switch screen {
                case .createUser(let lineUser):
                    let viewController = UserRegistrationViewController.make(type: .create(lineUser: lineUser))
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .updateUser(let user):
                    let viewController = UserRegistrationViewController.make(type: .update(user: user))
                    self.navigationController?.pushViewController(viewController, animated: true)
                default: break
                }
            })
            .disposed(by: disposeBag)

        viewModel.completedSubject
            .filter { $0 }
            .subscribe(onNext: { _ in
                HUD.flash(.success, delay: 1.0)
            })
            .disposed(by: disposeBag)

        viewModel.isSignedIn
            .subscribe(onNext: { [unowned self] in
                self.profileCardView.isHidden = !$0
                self.loginStackView.isHidden = $0
                self.settingBarButtonItem.isEnabled = $0
                self.settingBarButtonItem.tintColor = $0 ? UIColor.systemBlue : UIColor.clear
            })
            .disposed(by: disposeBag)

        viewModel.user
            .filterNil()
            .subscribe(onNext: { [unowned self] user in
                self.nameLabel.text = user.name
                self.birthdayLabel.text = DateFormat.yyyyMMdd.string(from: user.birthday)
                if let imageData = user.iconImage,
                   imageData != Data() {
                    self.iconImageView.image = UIImage(data: imageData)
                } else {
                    self.iconImageView.pin_setImage(from: user.iconImageURL)
                }
            })
            .disposed(by: disposeBag)

        settingBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.handleSettingBarButtonItem()
            })
            .disposed(by: disposeBag)

        editButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.handleEditButton()
            })
            .disposed(by: disposeBag)

        lineLoginButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                LoginManager.shared.login(permissions: [.profile, .openID], in: self) { result in
                    switch result {
                    case .success(let loginResult):
                        let lineUser = LineUser(loginResult: loginResult)
                        self.viewModel.handleLineLoginWithSuccess(lineUser: lineUser)
                    case .failure(let error):
                        self.viewModel.handleLineLoginWithError(error: error)
                    }
                }
            })
            .disposed(by: disposeBag)

        appleLoginButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TextFieldInputAccessoryViewDelegate
extension MypageViewController: TextFieldInputAccessoryViewDelegate {}

// MARK: ASAuthorizationControllerDelegate
extension MypageViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.handleCompletedAppleSignin(authorization)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        viewModel.handleFailureAppleSignin(error)
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding
extension MypageViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
