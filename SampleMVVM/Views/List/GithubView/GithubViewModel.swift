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
    var presentViewController: Driver<UIViewController> { get }
    var pushViewController: Driver<UIViewController> { get }
    func fetchRepositories(query: String?) -> Completable
    func showGithubWebView(indexPath: IndexPath)
}

final class GithubViewModel {
    private let apiGateway: APIGatewayProtocol = APIGateway()
    private let disposeBag = DisposeBag()

    var isLoading = BehaviorRelay<Bool>(value: false)

    private let repositoriesSubject = BehaviorRelay<[GithubRepository]>(value: [])
    var repositories: Driver<[GithubRepository]> {
        return repositoriesSubject.asDriver(onErrorJustReturn: [])
    }

    private var presentViewControllerSubject = PublishRelay<UIViewController>()
    var presentViewController: Driver<UIViewController> {
        return presentViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private var pushViewControllerSubject = PublishRelay<UIViewController>()
    var pushViewController: Driver<UIViewController> {
        return pushViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }
}

extension GithubViewModel: GithubViewModelable {
    func fetchRepositories(query: String?) -> Completable {
        guard let query = query else {
            return Completable.empty()
        }
        isLoading.accept(true)
        return apiGateway.fetchGithubRepositories(query: query)
            .do(
                onSuccess: { [weak self] repositories in
                    self?.isLoading.accept(false)
                    self?.repositoriesSubject.accept(repositories)
                },
                onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.presentViewControllerSubject
                        .accept(UIAlertController.singleErrorAlert(message: error.localizedDescription))})
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    func showGithubWebView(indexPath: IndexPath) {
        guard let url = URL(string: repositoriesSubject.value[indexPath.row].htmlUrl) else { return }
        let viewController = SFSafariViewController(url: url)
        pushViewControllerSubject.accept(viewController)
    }
}