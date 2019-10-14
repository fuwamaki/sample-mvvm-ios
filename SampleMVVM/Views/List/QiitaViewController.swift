//
//  QiitaViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class QiitaViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: QiitaViewModelable = QiitaViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func setupTableView() {
    }

    private func bind() {
    }
}
