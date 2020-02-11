//
//  GithubViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa
import SafariServices

protocol GithubViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var searchQuery: BehaviorRelay<String?> { get }
    var searchedQuery: BehaviorRelay<String?> { get }
    var searchQueryValid: Observable<Bool> { get }
    var searchedQueryValid: Observable<Bool> { get }
    var repositories: Driver<[GithubRepository]> { get }
    var pushViewController: Driver<UIViewController> { get }
    var presentViewController: Driver<UIViewController> { get }
    func handleSearchButton() -> Completable
    func handleFavoriteBarButton() -> Completable
    func showGithubWebView(indexPath: IndexPath)
}

final class GithubViewModel {

    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var searchQuery = BehaviorRelay<String?>(value: nil)
    private(set) var searchedQuery = BehaviorRelay<String?>(value: nil)

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

    private let repositoriesSubject = BehaviorRelay<[GithubRepository]>(value: [])
    var repositories: Driver<[GithubRepository]> {
        return repositoriesSubject.asDriver(onErrorJustReturn: [])
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
    }
}

extension GithubViewModel: GithubViewModelable {
    func handleSearchButton() -> Completable {
        guard let query = searchQuery.value else {
            return Completable.empty()
        }
        return fetchRepositories(query: query)
    }

    func handleFavoriteBarButton() -> Completable {
        guard let keyword = searchedQuery.value else { return Completable.empty() }
        return itemExists(keyword: keyword)
            .flatMapCompletable { [weak self] in
                guard let `self` = self else {
                    return Completable.empty()
                }
                guard !$0 else {
                    let errorAlert = UIAlertController.singleErrorAlert(message: "既にお気に入り済みのキーワードです")
                    self.presentViewControllerSubject.accept(errorAlert)
                    return Completable.empty()
                }
                return self.saveGithubItem(keyword: keyword)
        }
    }

    func showGithubWebView(indexPath: IndexPath) {
        guard let url = URL(string: repositoriesSubject.value[indexPath.row].htmlUrl) else { return }
        let viewController = SFSafariViewController(url: url)
        viewController.hidesBottomBarWhenPushed = true
        pushViewControllerSubject.accept(viewController)
    }
}

// MARK: private UseCase
extension GithubViewModel {
    private func saveGithubItem(keyword: String) -> Completable {
        let entity = ListRealmEntity.make(keyword: keyword, type: .github)
        return ItemRealmRepository<ListRealmEntity>.save(item: entity)
            .do(
                onError: { [weak self] error in
                    let errorAlert = UIAlertController.singleErrorAlert(message: error.localizedDescription)
                    self?.presentViewControllerSubject.accept(errorAlert)
                },
                onCompleted: {
                    UserDefaultsRepository.shared.oneUp(type: .incrementListId)
            })
    }

    // 保存するキーワードが、既にローカルデータに保存済みかどうかを確認
    private func itemExists(keyword: String) -> Single<Bool> {
        return Single<Bool>.create { single in
            ItemRealmRepository<ListRealmEntity>.find(keyword: keyword, type: .github)
                .subscribe(
                    onNext: { entity in
                        single(.success(entity != nil))
                },
                    onError: { error in
                        single(.error(error))
                })
        }
    }

    private func fetchRepositories(query: String) -> Completable {
        isLoading.accept(true)
        return apiClient.fetchGithubRepositories(query: query)
            .do(
                onSuccess: { [weak self] repositories in
                    self?.searchedQuery.accept(query)
                    self?.isLoading.accept(false)
                    self?.repositoriesSubject.accept(repositories)
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    let errorAlert = UIAlertController.singleErrorAlert(message: error.message)
                    self?.presentViewControllerSubject.accept(errorAlert) })
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }
}
