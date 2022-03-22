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
    var pushScreen: Driver<Screen> { get }
    var presentScreen: Driver<Screen> { get }
    func handleRegisterBarButtonItem()
    func handleTableItemButton(indexPath: IndexPath?)
    func fetchItems() -> Completable
    func deleteItem(indexPath: IndexPath) -> Completable
}

final class ItemViewModel {

    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var viewWillAppear = PublishRelay<Void>()

    private let itemsSubject = BehaviorRelay<[Item]>(value: [])
    var items: Driver<[Item]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    private var pushScreenSubject = PublishRelay<Screen>()
    var pushScreen: Driver<Screen> {
        return pushScreenSubject.asDriver(onErrorJustReturn: .other)
    }

    private var presentScreenSubject = PublishRelay<Screen>()
    var presentScreen: Driver<Screen> {
        return presentScreenSubject.asDriver(onErrorJustReturn: .other)
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

// MARK: ItemViewModelable
extension ItemViewModel: ItemViewModelable {
    func handleRegisterBarButtonItem() {
        pushScreenSubject.accept(.itemRegister)
    }

    func handleTableItemButton(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        pushScreenSubject.accept(.itemUpdate(
            item: itemsSubject.value[indexPath.row]
        ))
    }

    func fetchItems() -> Completable {
        isLoading.accept(true)
        return apiClient.fetchItems()
            .do(
                onSuccess: { [weak self] response in
                    self?.isLoading.accept(false)
                    self?.itemsSubject.accept(response)
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.presentScreenSubject
                        .accept(.errorAlert(message: error.message))
                }
            ).map { _ in }
            .asCompletable()
    }

    func deleteItem(indexPath: IndexPath) -> Completable {
        isLoading.accept(true)
        guard let id = itemsSubject.value[indexPath.row].id else {
            fatalError("the item do not have id.")
        }
        return apiClient.deleteItem(id: id)
            .do(
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.presentScreenSubject
                        .accept(.errorAlert(message: error.message))
                },
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    var items = self?.itemsSubject.value
                    items?.remove(at: indexPath.row)
                    self?.itemsSubject.accept(items ?? [])
                }
            )
    }
}
