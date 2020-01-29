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

final class ItemRegisterViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    private var textFields: [UITextField] {
        return [nameTextField, categoryTextField, priceTextField]
    }

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
    private var viewModel: ItemRegisterViewModelable = ItemRegisterViewModel()
    private var item: Item?

    static func make() -> ItemRegisterViewController {
        let viewController = R.storyboard.itemRegisterViewController.instantiateInitialViewController()!
        return viewController
    }

    static func make(item: Item) -> ItemRegisterViewController {
        let viewController = R.storyboard.itemRegisterViewController.instantiateInitialViewController()!
        viewController.item = item
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItem()
        setupViews()
        setupTexts()
        bind()
    }

    private func setupItem() {
        viewModel.editItem = item
        viewModel.setupItem()
    }

    private func setupViews() {
        view.addSubview(indicator)
        textFields.enumerated().forEach {
            let previous: UITextField? = $0 == 0 ? nil : textFields[$0-1]
            let next: UITextField? = $0 == textFields.count-1 ? nil : textFields[$0+1]
            let inputAccessoryView = TextFieldInputAccessoryView(textField: $1, previous: previous, next: next)
            inputAccessoryView.delegate = self
            $1.inputAccessoryView = inputAccessoryView
            $1.delegate = self
        }
        switch viewModel.mode {
        case .register:
            registerButton.setTitle(R.string.localizable.item_register_create_button(), for: .normal)
        case .update:
            registerButton.setTitle(R.string.localizable.item_register_update_button(), for: .normal)
        }
    }

    private func setupTexts() {
        title = R.string.localizable.item_register_title()
        nameLabel.text = R.string.localizable.item_register_name()
        categoryLabel.text = R.string.localizable.item_register_category()
        priceLabel.text = R.string.localizable.item_register_price()
        nameTextField.placeholder = R.string.localizable.item_register_name_placeholder()
        categoryTextField.placeholder = R.string.localizable.item_register_category_placeholder()
        priceTextField.placeholder = R.string.localizable.item_register_price_placeholder()
    }

    // swiftlint:disable function_body_length
    private func bind() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] in
                self?.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.presentViewController
            .drive(onNext: { [unowned self] viewController in
                self.present(viewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.dismissSubject
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?
                    .popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.completedSubject
            .filter { $0 }
            .subscribe(onNext: { _ in
                HUD.flash(.success, delay: 1.0)
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

extension ItemRegisterViewController: TextFieldInputAccessoryViewDelegate {}

extension ItemRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let index = textFields.firstIndex(of: textField) else { return true }
        let nextIndex = index + 1
        if nextIndex < textFields.endIndex {
            textFields[nextIndex].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            viewModel.handleRegisterButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        return true
    }
}
