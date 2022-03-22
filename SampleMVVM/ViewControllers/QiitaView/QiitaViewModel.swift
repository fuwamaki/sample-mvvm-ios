//
//  QiitaViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol QiitaViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var completedSubject: BehaviorRelay<Bool> { get }
    var searchQuery: BehaviorRelay<String?> { get }
    var searchedQuery: BehaviorRelay<String?> { get }
    var isQueryFavorited: BehaviorRelay<Bool> { get }
    var searchQueryValid: Observable<Bool> { get }
    var searchedQueryValid: Observable<Bool> { get }
    var qiitaItems: Driver<[QiitaItem]> { get }
    var presentScreen: Driver<Screen> { get }
    func handleSearchButton() -> Completable
    func handleFavoriteBarButton() -> Completable
    func showQiitaWebView(indexPath: IndexPath)
}

final class QiitaViewModel {

    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var completedSubject = BehaviorRelay<Bool>(value: false)
    private(set) var searchQuery = BehaviorRelay<String?>(value: nil)
    private(set) var searchedQuery = BehaviorRelay<String?>(value: nil)
    private(set) var isQueryFavorited = BehaviorRelay<Bool>(value: false)

    lazy var searchQueryValid: Observable<Bool> = {
        return searchQuery
            .map { ($0 ?? "").count > 0 }
            .share(replay: 1)
    }()

    lazy var searchedQueryValid: Observable<Bool> = {
        return searchedQuery
            .map { ($0 ?? "").count > 0 }
            .share(replay: 1)
    }()

    private let qiitaItemsSubject = BehaviorRelay<[QiitaItem]>(value: [])
    var qiitaItems: Driver<[QiitaItem]> {
        return qiitaItemsSubject.asDriver(onErrorJustReturn: [])
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
    }
}

// MARK: private UseCase
extension QiitaViewModel {
    private func saveQiitaItem(keyword: String) -> Completable {
        let entity = ListRealmEntity.make(keyword: keyword, type: .qiita)
        return ItemRealmRepository<ListRealmEntity>.save(item: entity)
            .do(
                onError: { [weak self] error in
                    self?.presentScreenSubject
                        .accept(.errorAlert(message: error.localizedDescription))
                },
                onCompleted: { [weak self] in
                    UserDefaultsRepository.shared.oneUp(type: .incrementListId)
                    self?.isQueryFavorited.accept(true)
                    self?.completedSubject.accept(true)
                }
            )
    }

    // 保存するキーワードが、既にローカルデータに保存済みかどうかを確認
    private func itemExists(keyword: String) -> Single<Bool> {
        return Single<Bool>.create { single in
            ItemRealmRepository<ListRealmEntity>.find(keyword: keyword, type: .qiita)
                .subscribe(
                    onNext: { entity in
                        single(.success(entity != nil))
                    },
                    onError: { error in
                        single(.error(error))
                    }
                )
        }
    }

    private func fetchQiitaItems(tag: String) -> Completable {
        isLoading.accept(true)
        return apiClient.fetchQiitaItems(tag: tag)
            .do(
                onSuccess: { [weak self] items in
                    self?.isLoading.accept(false)
                    self?.qiitaItemsSubject.accept(items)
                    self?.searchedQuery.accept(tag)
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.presentScreenSubject
                        .accept(.errorAlert(message: error.message))
                }
            )
            .map { _ in }
            .asCompletable()
    }
}

// MARK: QiitaViewModelable
extension QiitaViewModel: QiitaViewModelable {
    func handleSearchButton() -> Completable {
        guard let tag = searchQuery.value else {
            return Completable.empty()
        }
        itemExists(keyword: tag)
            .subscribe(onSuccess: { [weak self] in
                self?.isQueryFavorited.accept($0)
            })
            .disposed(by: disposeBag)
        return fetchQiitaItems(tag: tag)
    }

    func handleFavoriteBarButton() -> Completable {
        guard let keyword = searchedQuery.value else {
            return Completable.empty()
        }
        return itemExists(keyword: keyword)
            .flatMapCompletable { [weak self] in
                guard let `self` = self else {
                    return Completable.empty()
                }
                guard !$0 else {
                    self.presentScreenSubject
                        .accept(.errorAlert(message: R.string.localizable.error_already_favorite()))
                    return Completable.empty()
                }
                return self.saveQiitaItem(keyword: keyword)
            }
    }

    func showQiitaWebView(indexPath: IndexPath) {
        guard let url = URL(string: qiitaItemsSubject.value[indexPath.row].url) else { return }
        presentScreenSubject.accept(.safari(url: url))
    }
}
