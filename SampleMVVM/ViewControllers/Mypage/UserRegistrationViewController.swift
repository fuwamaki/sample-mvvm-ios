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
        birthdayTextField.inputView = birthdayPickerView
    }

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

        changeImageButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.handleChangeImageButton()
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

extension UserRegistrationViewController: TextFieldInputAccessoryViewDelegate {}
