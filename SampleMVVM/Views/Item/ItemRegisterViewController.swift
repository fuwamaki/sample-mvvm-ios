//
//  ItemRegisterViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/29.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemRegisterViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    private let disposeBag = DisposeBag()
    private let viewModel: ItemRegisterViewModelable = ItemRegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        viewModel.dismissSubject
            .subscribe(onNext: { [weak self] isDismiss in
                if isDismiss {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)

        viewModel.nameText
            .asDriver(onErrorJustReturn: "")
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)

        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)

        viewModel.categoryText
            .asDriver(onErrorJustReturn: "")
            .drive(categoryTextField.rx.text)
            .disposed(by: disposeBag)

        categoryTextField.rx.text.orEmpty
            .bind(to: viewModel.categoryText)
            .disposed(by: disposeBag)

        viewModel.priceText
            .asDriver(onErrorJustReturn: "")
            .drive(priceTextField.rx.text)
            .disposed(by: disposeBag)

        priceTextField.rx.text.orEmpty
            .bind(to: viewModel.priceText)
            .disposed(by: disposeBag)

        viewModel.allFieldsValid
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.postItem()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
