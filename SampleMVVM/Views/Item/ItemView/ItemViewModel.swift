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
    var pushRegister: Driver<ItemRegisterViewController> { get }
    var errorAlertMessage: Driver<String> { get }
    func showRegister(indexPath: IndexPath?)
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

    private var pushRegisterSubject = PublishRelay<ItemRegisterViewController>()
    var pushRegister: Driver<ItemRegisterViewController> {
        return pushRegisterSubject.asDriver(onErrorJustReturn: ItemRegisterViewController())
    }

    private var errorAlertMessageSubject = PublishRelay<String>()
    var errorAlertMessage: Driver<String> {
        return errorAlertMessageSubject.asDriver(onErrorJustReturn: "")
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
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.errorAlertMessageSubject.accept(error.message)})
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
                    self?.errorAlertMessageSubject.accept(error.message)},
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    var items = self?.itemsSubject.value
                    items?.remove(at: indexPath.row)
                    self?.itemsSubject.accept(items ?? [])})
    }
}
