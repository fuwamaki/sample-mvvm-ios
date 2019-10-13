//
//  ItemRegisterViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/29.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ItemRegisterViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var dismissSubject: BehaviorRelay<Bool> { get }
    var itemId: BehaviorRelay<Int?> { get }
    var nameText: BehaviorRelay<String?> { get }
    var categoryText: BehaviorRelay<String?> { get }
    var priceText: BehaviorRelay<String?> { get }
    var allFieldsValid: Observable<Bool> { get }
    func postItem() -> Completable
}

final class ItemRegisterViewModel {

    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()

    var isLoading = BehaviorRelay<Bool>(value: false)
    var dismissSubject = BehaviorRelay<Bool>(value: false)
    var itemId = BehaviorRelay<Int?>(value: nil)
    var nameText = BehaviorRelay<String?>(value: nil)
    var categoryText = BehaviorRelay<String?>(value: nil)
    var priceText = BehaviorRelay<String?>(value: nil)

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
}

extension ItemRegisterViewModel: ItemRegisterViewModelable {
    func postItem() -> Completable {
        guard let name = nameText.value, let category = categoryText.value,
            let priceStr = priceText.value, let price = Int(priceStr) else {
                return Completable.empty()
        }
        isLoading.accept(true)
        let item = Item(id: nil, name: name, category: category, price: price)
        return apiClient.postItem(item: item)
            .do(
                onError: { error in
                    debugPrint("Error: \(error)")},
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                    self?.dismissSubject.accept(true)
                })
    }
}
