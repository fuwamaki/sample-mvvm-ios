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
import PKHUD

enum ItemRegisterMode {
    case register
    case update
}

final class ItemRegisterViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    private var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.isLoading ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
            }
        }
    }

    private let disposeBag = DisposeBag()
    private var viewModel: ItemRegisterViewModelable = ItemRegisterViewModel()

    public var item: Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItem()
        bind()
    }

    private func setupItem() {
        viewModel.editItem = item
        viewModel.setupItem()
    }

    private func bind() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] in
                self?.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.dismissSubject
            .subscribe(onNext: { [weak self] isDismiss in
                if isDismiss {
                    self?.navigationController?
                        .popViewController(animated: true)
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
                self.viewModel.handleRegisterButton()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
