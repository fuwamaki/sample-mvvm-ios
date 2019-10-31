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

final class MypageViewController: UIViewController {

    @IBOutlet weak var textTextField: UITextField!

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
        textTextField.inputView = pickerView
        let inputAccessoryView = TextFieldInputAccessoryView(textField: textTextField)
        inputAccessoryView.delegate = self
        textTextField.inputAccessoryView = inputAccessoryView
    }

    private func bind() {
        picker.selectedContent
            .subscribe(onNext: { [unowned self] text in
                self.textTextField.text = text
            })
            .disposed(by: disposeBag)
    }
}

extension MypageViewController: TextFieldInputAccessoryViewDelegate {}
