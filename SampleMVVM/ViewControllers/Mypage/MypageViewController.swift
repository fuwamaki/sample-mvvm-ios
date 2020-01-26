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

    @IBOutlet private weak var profileCardView: UIView!
    @IBOutlet private weak var iconImageView: UIStackView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var lineLoginButton: UIButton!

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
    private let viewModel: MypageViewModelable = MypageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    private func setupViews() {
        view.addSubview(indicator)
    }

    private func bind() {
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .subscribe(onNext: { [unowned self] in
                self.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.presentViewController
            .drive(onNext: { [unowned self] viewController in
                self.present(viewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.pushViewController
            .drive(onNext: { [unowned self] viewController in
                self.navigationController?
                    .pushViewController(viewController, animated: true)})
            .disposed(by: disposeBag)

        viewModel.isSignedIn
            .subscribe(onNext: { [unowned self] in
                self.profileCardView.isHidden = !$0
                self.lineLoginButton.isHidden = $0
            })
            .disposed(by: disposeBag)

        lineLoginButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.handleLineLoginButton(viewController: self)
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

extension MypageViewController: TextFieldInputAccessoryViewDelegate {}
