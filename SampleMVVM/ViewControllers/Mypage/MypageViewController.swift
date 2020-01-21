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
import LineSDK

final class MypageViewController: UIViewController {

    @IBOutlet weak var test1TextField: UITextField!
    @IBOutlet weak var test2TextField: UITextField!
    private var testTextFields: [UITextField] {
        return [test1TextField, test2TextField]
    }

    private let disposeBag = DisposeBag()
    private let viewModel: MypageViewModelable = MypageViewModel()

    private let pickerView = UIPickerView()
    private let picker = CustomPicker()
    private let array = ["1", "2", "3", "4", "5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    private func setupViews() {
        picker.array = array
        pickerView.delegate = picker
        pickerView.dataSource = picker
        testTextFields.enumerated().forEach {
            let previous: UITextField? = $0 == 0 ? nil : testTextFields[$0-1]
            let next: UITextField? = $0 == testTextFields.count-1 ? nil : testTextFields[$0+1]
            $1.inputView = pickerView
            let inputAccessoryView = TextFieldInputAccessoryView(textField: $1, previous: previous, next: next)
            inputAccessoryView.delegate = self
            $1.inputAccessoryView = inputAccessoryView
        }

        // Create Login Button.
        let loginBtn = LoginButton()
        loginBtn.delegate = self

        // Configuration for permissions and presenting.
        loginBtn.permissions = [.profile]
        loginBtn.presentingViewController = self

        // Add button to view and layout it.
        view.addSubview(loginBtn)
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loginBtn,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: loginBtn,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
    }

    private func bind() {
        picker.selectedContent
            .subscribe(onNext: { [unowned self] text in
                self.test1TextField.text = text
            })
            .disposed(by: disposeBag)
    }
}

extension MypageViewController: TextFieldInputAccessoryViewDelegate {}

extension MypageViewController: LoginButtonDelegate {
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        print("Login Succeeded.")
    }

    func loginButton(_ button: LoginButton, didFailLogin error: Error) {
        print("Error: \(error)")
    }

    func loginButtonDidStartLogin(_ button: LoginButton) {
        print("Login Started.")
    }
}
