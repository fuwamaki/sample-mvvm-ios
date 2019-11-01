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
