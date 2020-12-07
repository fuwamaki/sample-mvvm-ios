//
//  UserRegistrationViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/25.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import PINRemoteImage
import CropViewController
import PKHUD

enum UserRegistrationType {
    case create(lineUser: LineUser)
    case update(user: User)
}

final class UserRegistrationViewController: UIViewController {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var changeImageButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var birthdayTextField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!

    private var textFields: [UITextField] {
        return [nameTextField, birthdayTextField]
    }

    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()

    private let disposeBag = DisposeBag()
    private var viewModel: UserRegistrationViewModelable?
    private let birthdayPickerView = BirthdayPickerView()

    static func make(type: UserRegistrationType) -> UserRegistrationViewController {
        let viewController = R.storyboard.userRegistrationViewController.instantiateInitialViewController()!
        viewController.viewModel = UserRegistrationViewModel(type: type)
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTexts()
        bind()
    }

    private func setupViews() {
        textFields.enumerated().forEach {
            let previous: UITextField? = $0 == 0 ? nil : textFields[$0-1]
            let next: UITextField? = $0 == textFields.count-1 ? nil : textFields[$0+1]
            let inputAccessoryView = TextFieldInputAccessoryView(textField: $1, previous: previous, next: next)
            inputAccessoryView.delegate = self
            $1.inputAccessoryView = inputAccessoryView
        }
        if let birthday = viewModel?.birthday.value {
            birthdayPickerView.selectRow(date: birthday)
        }
        birthdayTextField.inputView = birthdayPickerView
    }

    private func setupTexts() {
        title = R.string.localizable.user_registration_title()
        changeImageButton.setTitle(R.string.localizable.user_registration_select_image(), for: .normal)
        nameLabel.text = R.string.localizable.user_registration_name()
        birthdayLabel.text = R.string.localizable.user_registration_birthday()
        nameTextField.placeholder = R.string.localizable.user_registration_name_placeholder()
        birthdayTextField.placeholder = R.string.localizable.user_registration_birthday_placeholder()
        switch viewModel?.type {
        case .create:
            submitButton.setTitle(R.string.localizable.user_registration_create_button(), for: .normal)
        case .update:
            submitButton.setTitle(R.string.localizable.user_registration_update_button(), for: .normal)
        default:
            break
        }
    }

    // swiftlint:disable function_body_length
    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.dismissSubject
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.completedSubject
            .filter { $0 }
            .subscribe(onNext: { _ in
                HUD.flash(.success, delay: 1.0)
            })
            .disposed(by: disposeBag)

        viewModel.presentScreen
            .drive(onNext: { [unowned self] screen in
                switch screen {
                case .imagePicker:
                    self.present(self.imagePickerController, animated: true, completion: nil)
                case .crop(let picker, let image):
                    let cropViewController = CropViewController(croppingStyle: .circular, image: image)
                    cropViewController.delegate = self
                    picker.pushViewController(cropViewController, animated: true)
                case .errorAlert(let message):
                    let alert = UIAlertController.singleErrorAlert(message: message)
                    self.present(alert, animated: true, completion: nil)
                case .errorAlertAndDismiss(let message):
                    let alert = UIAlertController.singleErrorAlert(message: message)
                    self.present(alert, animated: true) {
                        self.navigationController?.popViewController(animated: true)
                    }
                default: break
                }
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(viewModel.iconImageURL, viewModel.uploadImage)
            .subscribe(onNext: { url, image in
                if let image = image {
                    self.iconImageView.image = image
                } else {
                    self.iconImageView.pin_setImage(from: url)
                }
            })
            .disposed(by: disposeBag)

        changeImageButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel?.handleChangeImageButton()
            })
            .disposed(by: disposeBag)

        viewModel.name
            .asDriver(onErrorJustReturn: "")
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)

        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)

        viewModel.birthday
            .filterNil()
            .subscribe(onNext: { [unowned self] birthday in
                self.birthdayTextField.text = DateFormat.yyyyMMdd.string(from: birthday)
            })
            .disposed(by: disposeBag)

        birthdayPickerView.selectedDate
            .filterNil()
            .subscribe(onNext: { [unowned self] date in
                viewModel.birthday.accept(date)
                self.birthdayTextField.text = DateFormat.yyyyMMdd.string(from: date)
            })
            .disposed(by: disposeBag)

        submitButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel?.handleSubmitButton()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UIImagePickerControllerDelegate
extension UserRegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        viewModel?.imagePicker(picker, info: info)
    }
}

// MARK: CropViewControllerDelegate
extension UserRegistrationViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        viewModel?.cropView(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: UINavigationControllerDelegate
extension UserRegistrationViewController: UINavigationControllerDelegate {}

// MARK: TextFieldInputAccessoryViewDelegate
extension UserRegistrationViewController: TextFieldInputAccessoryViewDelegate {}
