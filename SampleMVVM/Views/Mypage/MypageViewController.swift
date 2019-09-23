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

    private let disposeBag = DisposeBag()
    private let viewModel: MypageViewModelable = MypageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
    }
}
