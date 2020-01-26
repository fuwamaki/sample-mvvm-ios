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
import RxOptional
import PINRemoteImage

final class MypageViewController: UIViewController {

    @IBOutlet private weak var settingBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var profileCardView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
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
        profileCardView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        profileCardView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        profileCardView.layer.shadowOpacity = 0.8
        profileCardView.layer.masksToBounds = false
        iconImageView.layer.shadowColor = UIColor.label.cgColor
        iconImageView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    }

    // swiftlint:disable function_body_length
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

        viewModel.user
            .filterNil()
            .subscribe(onNext: { [unowned self] user in
                self.nameLabel.text = user.name
                self.birthdayLabel.text = DateFormat.yyyyMMdd.string(from: user.birthday)
                self.iconImageView.pin_setImage(from: user.iconImageURL)
            })
            .disposed(by: disposeBag)

        settingBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.handleSettingBarButtonItem()
            })
            .disposed(by: disposeBag)

        editButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.handleEditButton()
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
