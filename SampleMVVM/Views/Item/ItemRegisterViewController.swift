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
    }
}
