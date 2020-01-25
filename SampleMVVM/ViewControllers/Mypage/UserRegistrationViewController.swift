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
    private let viewModel: UserRegistrationViewModelable = UserRegistrationViewModel()
    private let birthdayPickerView = BirthdayPickerView()

    static func make() -> UserRegistrationViewController {
        let viewController = R.storyboard.userRegistrationViewController.instantiateInitialViewController()!
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
        changeImageButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.handleChangeImageButton()
            })
            .disposed(by: disposeBag)

        birthdayPickerView.selectedDate
            .filterNil()
            .subscribe(onNext: { [unowned self] date in
                self.viewModel.residence.accept(date)
                self.birthdayTextField.text = DateFormat.yyyyMMdd.string(from: date)
            })
            .disposed(by: disposeBag)

        submitButton.rx.tap
        .subscribe(onNext: { [unowned self] in
            self.viewModel.handleSubmitButton()
        })
        .disposed(by: disposeBag)
    }
}

extension UserRegistrationViewController: TextFieldInputAccessoryViewDelegate {}
