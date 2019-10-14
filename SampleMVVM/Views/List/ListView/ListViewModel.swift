//
//  ListViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ListViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var pushViewController: Driver<UIViewController> { get }
    func showGithubView()
    func showQiitaView()
}

final class ListViewModel {

    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()

    var isLoading = BehaviorRelay<Bool>(value: false)
    var viewWillAppear = PublishRelay<Void>()

    private var pushViewControllerSubject = PublishRelay<UIViewController>()
    var pushViewController: Driver<UIViewController> {
        return pushViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    required init() {
        subscribe()
    }

    private func subscribe() {
        viewWillAppear
            .subscribe(onNext: { [unowned self] in
                // TODO
                print("TODO")
            })
            .disposed(by: disposeBag)
    }
}

extension ListViewModel: ListViewModelable {
    func showGithubView() {
        let viewController = R.storyboard.githubViewController.instantiateInitialViewController()!
        pushViewControllerSubject.accept(viewController)
    }

    func showQiitaView() {
        let viewController = R.storyboard.qiitaViewController.instantiateInitialViewController()!
        pushViewControllerSubject.accept(viewController)
    }
}
