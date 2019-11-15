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
    var repositories: Driver<[GithubRepository]> { get }
    var pushViewController: Driver<UIViewController> { get }
    var errorAlertMessage: Driver<String> { get }
    func fetchRepositories(query: String?) -> Completable
    func showGithubWebView(indexPath: IndexPath)
    func saveKeyword(query: String?)
}

final class GithubViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)

    private let repositoriesSubject = BehaviorRelay<[GithubRepository]>(value: [])
    var repositories: Driver<[GithubRepository]> {
        return repositoriesSubject.asDriver(onErrorJustReturn: [])
    }

    private var pushViewControllerSubject = PublishRelay<UIViewController>()
    var pushViewController: Driver<UIViewController> {
        return pushViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
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
    }
}

extension GithubViewModel: GithubViewModelable {
    func fetchRepositories(query: String?) -> Completable {
        guard let query = query else {
            return Completable.empty()
        }
        isLoading.accept(true)
        return apiClient.fetchGithubRepositories(query: query)
            .do(
                onSuccess: { [weak self] repositories in
                    self?.isLoading.accept(false)
                    self?.repositoriesSubject.accept(repositories)
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.errorAlertMessageSubject.accept(error.message)})
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    func saveKeyword(query: String?) {
        guard let query = query else { return }
        let entity = ListRealmEntity()
        entity.itemId = UserDefaultsRepository.shared.incrementListId ?? 0
        entity.keyword = query
        entity.type = ListRealmType.github.rawValue
        RealmRepository<ListRealmEntity>.save(item: entity) { result in
            switch result {
            case .success:
                UserDefaultsRepository.shared.oneUp(type: .incrementListId)
                print("保存完了")
            case .failure:
                print("保存失敗")
            }
        }
    }

    func showGithubWebView(indexPath: IndexPath) {
        guard let url = URL(string: repositoriesSubject.value[indexPath.row].htmlUrl) else { return }
        let viewController = SFSafariViewController(url: url)
        viewController.hidesBottomBarWhenPushed = true
        pushViewControllerSubject.accept(viewController)
    }
}
