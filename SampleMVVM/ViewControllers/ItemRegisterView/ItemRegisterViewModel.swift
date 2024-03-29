//
//  ItemRegisterViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/29.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

enum ItemRegisterMode {
    case register
    case update
}

protocol ItemRegisterViewModelable {
    var editItem: Item? { get set }
    var mode: ItemRegisterMode { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var presentScreen: Driver<Screen> { get }
    var dismissSubject: BehaviorRelay<Bool> { get }
    var completedSubject: BehaviorRelay<Bool> { get }
    var itemId: BehaviorRelay<Int?> { get }
    var nameText: BehaviorRelay<String?> { get }
    var categoryText: BehaviorRelay<String?> { get }
    var priceText: BehaviorRelay<String?> { get }
    var allFieldsValid: Observable<Bool> { get }
    func setupItem()
    func handleRegisterButton() -> Completable
}

final class ItemRegisterViewModel {

    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var dismissSubject = BehaviorRelay<Bool>(value: false)
    private(set) var completedSubject = BehaviorRelay<Bool>(value: false)
    private(set) var itemId = BehaviorRelay<Int?>(value: nil)
    private(set) var nameText = BehaviorRelay<String?>(value: nil)
    private(set) var categoryText = BehaviorRelay<String?>(value: nil)
    private(set) var priceText = BehaviorRelay<String?>(value: nil)

    var editItem: Item?
    var mode: ItemRegisterMode {
        return editItem == nil ? .register : .update
    }

    lazy var nameValid: Observable<Bool> = {
        return nameText
            .map { ($0 ?? "").count > 0 }
            .share(replay: 1)
    }()

    lazy var categoryValid: Observable<Bool> = {
        return categoryText
            .map { ($0 ?? "").count > 0 }
            .share(replay: 1)
    }()

    lazy var priceValid: Observable<Bool> = {
        return priceText
            .map { ($0 ?? "").count > 0 }
            .share(replay: 1)
    }()

    lazy var allFieldsValid: Observable<Bool> = {
        return Observable
            .combineLatest(nameValid, categoryValid, priceValid) { $0 && $1 && $2 }
            .share(replay: 1)
    }()

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

    private func subscribe() {}

    private func postItem() -> Completable {
        guard let name = nameText.value,
              let category = categoryText.value,
              let priceStr = priceText.value,
              let price = Int(priceStr) else {
            return Completable.empty()
        }
        isLoading.accept(true)
        let item = Item(id: nil, name: name, category: category, price: price)
        return apiClient.postItem(item: item)
            .do(
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.presentScreenSubject
                        .accept(.errorAlert(message: error.message))
                },
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    self?.completedSubject.accept(true)
                    self?.dismissSubject.accept(true)
                }
            )
    }

    private func putItem() -> Completable {
        guard let name = nameText.value,
              let category = categoryText.value,
              let priceStr = priceText.value,
              let price = Int(priceStr) else {
            return Completable.empty()
        }
        isLoading.accept(true)
        let item = Item(id: nil, name: name, category: category, price: price)
        return apiClient.putItem(id: (editItem?.id)!, item: item)
            .do(
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.presentScreenSubject.accept(.errorAlert(message: error.message))
                },
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    self?.completedSubject.accept(true)
                    self?.dismissSubject.accept(true)
                }
            )
    }
}

// MARK: ItemRegisterViewModelable
extension ItemRegisterViewModel: ItemRegisterViewModelable {
    func setupItem() {
        guard let item = editItem else { return }
        nameText.accept(item.name)
        categoryText.accept(item.category)
        priceText.accept(String(item.price))
    }

    func handleRegisterButton() -> Completable {
        switch mode {
        case .register:
            return postItem()
        case .update:
            return putItem()
        }
    }
}
