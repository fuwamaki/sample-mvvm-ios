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
    var presentViewController: Driver<UIViewController> { get }
    var pushRegister: Driver<ItemRegisterViewController> { get }
    func showRegister(indexPath: IndexPath?)
    func fetchItems() -> Completable
    func deleteItem(indexPath: IndexPath) -> Completable
}

final class ItemViewModel {

    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()

    var isLoading = BehaviorRelay<Bool>(value: false)
    var viewWillAppear = PublishRelay<Void>()

    private let itemsSubject = BehaviorRelay<[Item]>(value: [])
    var items: Driver<[Item]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    private var presentViewControllerSubject = PublishRelay<UIViewController>()
    var presentViewController: Driver<UIViewController> {
        return presentViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private var pushRegisterSubject = PublishRelay<ItemRegisterViewController>()
    var pushRegister: Driver<ItemRegisterViewController> {
        return pushRegisterSubject.asDriver(onErrorJustReturn: ItemRegisterViewController())
    }

    required init() {
        subscribe()
    }

    private func subscribe() {
        viewWillAppear
        .subscribe(onNext: { [unowned self] in
            self.fetchItems().subscribe().disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
}

extension ItemViewModel: ItemViewModelable {
    func showRegister(indexPath: IndexPath?) {
        let viewController = R.storyboard.itemRegisterViewController.instantiateInitialViewController()!
        if let indexPath = indexPath {
            viewController.item = itemsSubject.value[indexPath.row]
        }
        pushRegisterSubject.accept(viewController)
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
                self?.presentViewControllerSubject
                    .accept(UIAlertController.singleErrorAlert(message: error.localizedDescription))
            }
        )
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
                    self?.isLoading.accept(false)
                    self?.presentViewControllerSubject
                        .accept(UIAlertController.singleErrorAlert(message: error.localizedDescription))},
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    var items = self?.itemsSubject.value
                    items?.remove(at: indexPath.row)
                    self?.itemsSubject.accept(items ?? [])})
    }
}
