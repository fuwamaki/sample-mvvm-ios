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

    private var textFields: [UITextField] {
        return [nameTextField, categoryTextField, priceTextField]
    }

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.link
        indicator.isHidden = true
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

    public var item: Item?

    static func make() -> ItemRegisterViewController {
        return R.storyboard.itemRegisterViewController.instantiateInitialViewController()!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItem()
        setupViews()
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
    }

    // swiftlint:disable function_body_length
    private func bind() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] in
                self?.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.errorAlertMessage
            .drive(onNext: { [unowned self] message in
                let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
