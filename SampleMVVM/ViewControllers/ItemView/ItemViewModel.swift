//
//  ItemViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ItemViewModelable {
    var items: Driver<[Item]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var pushViewController: Driver<UIViewController> { get }
    var presentViewController: Driver<UIViewController> { get }
    func handleRegisterBarButtonItem()
    func handleTableItemButton(indexPath: IndexPath?)
    func fetchItems() -> Completable
    func deleteItem(indexPath: IndexPath) -> Completable
}

final class ItemViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)
    var viewWillAppear = PublishRelay<Void>()

    private let itemsSubject = BehaviorRelay<[Item]>(value: [])
    var items: Driver<[Item]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    private var pushViewControllerSubject = PublishRelay<UIViewController>()
    var pushViewController: Driver<UIViewController> {
        return pushViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private var presentViewControllerSubject = PublishRelay<UIViewController>()
    var presentViewController: Driver<UIViewController> {
        return presentViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private let disposeBag = DisposeBag()
    private let apiClient: APIClientable

    convenience init() {
        self.init(apiClient: APIClient())
    }

    init(apiClient: APIClientable) {
        self.apiClient = apiClient
        subscribe()
    }

    private func subscribe() {
        viewWillAppear
            .subscribe(onNext: { [unowned self] in
                self.fetchItems()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

extension ItemViewModel: ItemViewModelable {
    func handleRegisterBarButtonItem() {
        let viewController = ItemRegisterViewController.make()
        pushViewControllerSubject.accept(viewController)
    }

    func handleTableItemButton(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let viewController = ItemRegisterViewController.make(item: itemsSubject.value[indexPath.row])
        pushViewControllerSubject.accept(viewController)
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
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    let errorAlert = UIAlertController.singleErrorAlert(message: error.message)
                    self?.presentViewControllerSubject.accept(errorAlert) })
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    func deleteItem(indexPath: IndexPath) -> Completable {
        isLoading.accept(true)
        guard let id = itemsSubject.value[indexPath.row].id else {
            fatalError("the item don't have id.")
        }
        return apiClient.deleteItem(id: id)
            .do(
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    let errorAlert = UIAlertController.singleErrorAlert(message: error.message)
                    self?.presentViewControllerSubject.accept(errorAlert) },
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    var items = self?.itemsSubject.value
                    items?.remove(at: indexPath.row)
                    self?.itemsSubject.accept(items ?? [])})
    }
}
