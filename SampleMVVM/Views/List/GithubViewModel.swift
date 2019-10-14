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
}

final class GithubViewModel {
    private let apiClient = APIClient()
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
}

extension GithubViewModel: GithubViewModelable {
    func fetchRepositories(query: String) -> Completable {
        isLoading.accept(true)
        return apiClient.fetchGithubRepositories(query: query)
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
}
