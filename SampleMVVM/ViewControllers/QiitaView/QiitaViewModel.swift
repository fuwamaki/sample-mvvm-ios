//
//  QiitaViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa
import SafariServices

protocol QiitaViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var searchQuery: BehaviorRelay<String?> { get }
    var searchedQuery: BehaviorRelay<String?> { get }
    var searchQueryValid: Observable<Bool> { get }
    var searchedQueryValid: Observable<Bool> { get }
    var qiitaItems: Driver<[QiitaItem]> { get }
    var pushViewController: Driver<UIViewController> { get }
    var presentViewController: Driver<UIViewController> { get }
    func fetchQiitaItems() -> Completable
    func saveKeyword()
    func showQiitaWebView(indexPath: IndexPath)
}

final class QiitaViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)

    private var pushViewControllerSubject = PublishRelay<UIViewController>()
    var pushViewController: Driver<UIViewController> {
        return pushViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private var presentViewControllerSubject = PublishRelay<UIViewController>()
    var presentViewController: Driver<UIViewController> {
        return presentViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    var searchQuery = BehaviorRelay<String?>(value: nil)
    var searchedQuery = BehaviorRelay<String?>(value: nil)

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
    }
}

extension QiitaViewModel: QiitaViewModelable {
    func fetchQiitaItems() -> Completable {
        guard let tag = searchQuery.value else {
            return Completable.empty()
        }
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
                    let errorAlert = UIAlertController.singleErrorAlert(message: error.message)
                    self?.presentViewControllerSubject.accept(errorAlert)
            })
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    // 保存するキーワードが、既に保存済みかどうか
    private func itemExists(keyword: String) -> Single<Bool> {
        return Single<Bool>.create { single in
            ItemRealmRepository<ListRealmEntity>.find(keyword: keyword, type: .qiita)
                .subscribe(
                    onNext: { entity in
                        single(.success(entity != nil))
                },
                    onError: { error in
                        single(.error(error))
                })
        }
    }

    func saveKeyword() {
        guard let query = searchedQuery.value else { return }
//        itemExists(keyword: query)
        let entity = ListRealmEntity.make(keyword: query, type: .qiita)
        ItemRealmRepository<ListRealmEntity>.save(item: entity) { [weak self] result in
            switch result {
            case .success:
                UserDefaultsRepository.shared.oneUp(type: .incrementListId)
            case .failure(let error):
                let errorAlert = UIAlertController.singleErrorAlert(message: error.description)
                self?.presentViewControllerSubject.accept(errorAlert)
            }
        }
    }

    func showQiitaWebView(indexPath: IndexPath) {
        guard let url = URL(string: qiitaItemsSubject.value[indexPath.row].url) else { return }
        let viewController = SFSafariViewController(url: url)
        viewController.hidesBottomBarWhenPushed = true
        pushViewControllerSubject.accept(viewController)
    }
}
