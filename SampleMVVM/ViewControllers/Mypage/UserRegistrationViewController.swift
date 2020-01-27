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

enum UserRegistrationType {
    case create(lineUser: LineUser)
    case update(user: User)
}

final class UserRegistrationViewController: UIViewController {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var changeImageButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
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
        bind()
        setupViews()
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

    // swiftlint:disable function_body_length
    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.dismissSubject
            .subscribe(onNext: { [weak self] isDismiss in
                if isDismiss {
                    self?.navigationController?
                        .popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)

        viewModel.presentViewController
            .drive(onNext: { [unowned self] viewController in
                self.present(viewController, animated: true, completion: nil)
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
                viewModel.handleChangeImageButton(self.imagePickerController)
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
        viewModel?.imagePicker(picker, info: info, viewController: self)
    }
}

// MARK: CropViewControllerDelegate
extension UserRegistrationViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        viewModel?.cropView(cropViewController, image: image)
    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension UserRegistrationViewController: UINavigationControllerDelegate {}
extension UserRegistrationViewController: TextFieldInputAccessoryViewDelegate {}
