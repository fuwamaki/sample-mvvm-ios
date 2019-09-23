//
//  ItemViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ItemViewModetable {
    var items: Driver<[Item]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var presentViewController: Driver<UIViewController> { get }
    func fetchItems() -> Completable
}

final class ItemViewModel {

    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()

    var isLoading = BehaviorRelay<Bool>(value: false)

    private let itemsSubject = BehaviorRelay<[Item]>(value: [])
    var items: Driver<[Item]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    private var presentViewControllerSubject = PublishRelay<UIViewController>()
    var presentViewController: Driver<UIViewController> {
        return presentViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    func fetchItems() -> Completable {
        isLoading.accept(true)
        return apiClient.fetchItems()
        .do(
            onSuccess: { [weak self] response in
                self?.isLoading.accept(false)
                self?.itemsSubject.accept([])
                self?.itemsSubject.accept(response)
            },
            onError: { [weak self] error in
                self?.presentViewControllerSubject.accept(UIAlertController.singleErrorAlert(message: error.localizedDescription))
            }
        )
        .map { _ in } // Single<Void>に変換
        .asCompletable() // Completableに変換
    }
}

extension ItemViewModel: ItemViewModetable {
}
