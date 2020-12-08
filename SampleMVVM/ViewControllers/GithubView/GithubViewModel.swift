//
//  GithubViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol GithubViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var completedSubject: BehaviorRelay<Bool> { get }
    var searchQuery: BehaviorRelay<String?> { get }
    var searchedQuery: BehaviorRelay<String?> { get }
    var searchQueryValid: Observable<Bool> { get }
    var searchedQueryValid: Observable<Bool> { get }
    var repositories: Driver<[GithubRepository]> { get }
    var presentScreen: Driver<Screen> { get }
    func handleSearchButton() -> Completable
    func handleFavoriteBarButton() -> Completable
    func showGithubWebView(indexPath: IndexPath)
}

final class GithubViewModel {

    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var completedSubject = BehaviorRelay<Bool>(value: false)
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
    }
}

// MARK: private UseCase
extension GithubViewModel {
    private func saveGithubItem(keyword: String) -> Completable {
        let entity = ListRealmEntity.make(keyword: keyword, type: .github)
        return ItemRealmRepository<ListRealmEntity>.save(item: entity)
            .do(
                onError: { [weak self] error in
                    self?.presentScreenSubject.accept(.errorAlert(message: error.localizedDescription))
                },
                onCompleted: { [weak self] in
                    UserDefaultsRepository.shared.oneUp(type: .incrementListId)
                    self?.completedSubject.accept(true)
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
                    self?.presentScreenSubject.accept(.errorAlert(message: error.message))
                })
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }
}

// MARK: GithubViewModelable
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
                    self.presentScreenSubject.accept(.errorAlert(message: R.string.localizable.error_already_favorite()))
                    return Completable.empty()
                }
                return self.saveGithubItem(keyword: keyword)
        }
    }

    func showGithubWebView(indexPath: IndexPath) {
        guard let url = URL(string: repositoriesSubject.value[indexPath.row].htmlUrl) else { return }
        presentScreenSubject.accept(.safari(url: url))
    }
}
