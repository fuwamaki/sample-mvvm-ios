//
//  ListViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

struct ListContents {
    let offset: Int
    let type: ListRealmType
    let contents: [Listable]
}

protocol ListViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var contents: Driver<[ListContents]> { get }
    var pushViewController: Driver<UIViewController> { get }
    func showGithubView()
    func showQiitaView()
}

final class ListViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)
    var viewWillAppear = PublishRelay<Void>()

    private var apiAccessCount = BehaviorRelay<Int>(value: 0)
    private var entitiesSubject = BehaviorRelay<[ListRealmEntity]>(value: [])

    private let contentsSubject = BehaviorRelay<[ListContents]>(value: [])
    var contents: Driver<[ListContents]> {
        return contentsSubject.asDriver(onErrorJustReturn: [])
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
        viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                RealmRepository<ListRealmEntity>.find { [weak self] result in
                    switch result {
                    case .success(let entities):
                        self?.entitiesSubject.accept(entities)
                        print(entities)
                    case .failure(let error):
                        self?.errorAlertMessageSubject.accept(error.description)
                    }
                }
            })
            .disposed(by: disposeBag)

        entitiesSubject
            .subscribe(onNext: { [unowned self] entities in
                entities.enumerated().forEach { offset, entity in
                    switch entity.type {
                    case .github:
                        self.fetchGithubRepositories(offset: offset, entity: entity)
                            .subscribe()
                            .disposed(by: self.disposeBag)
                    case .qiita:
                        self.fetchQiitaItems(offset: offset, entity: entity)
                            .subscribe()
                            .disposed(by: self.disposeBag)
                    case .other:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)

        apiAccessCount
            .subscribe(onNext: { [unowned self] count in
                self.isLoading.accept(count != 0)
            })
            .disposed(by: disposeBag)
    }

    private func fetchGithubRepositories(offset: Int, entity: ListRealmEntity) -> Completable {
        apiAccessCount.accept(apiAccessCount.value+1)
        return apiClient.fetchGithubRepositories(query: entity.keyword)
            .do(
                onSuccess: { [weak self] repositories in
                    guard let `self` = self else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    var contents = self.contentsSubject.value
                    let content = ListContents(offset: offset, type: .github, contents: repositories)
                    contents.append(content)
                    contents.sort { $0.offset < $1.offset }
                    self.contentsSubject.accept(contents)
                },
                onError: { [weak self] error in
                    guard let `self` = self, let error = error as? APIError else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    if self.apiAccessCount.value == 0 {
                        self.errorAlertMessageSubject.accept(error.message)
                    }})
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    private func fetchQiitaItems(offset: Int, entity: ListRealmEntity) -> Completable {
        apiAccessCount.accept(apiAccessCount.value+1)
        return apiClient.fetchQiitaItems(tag: entity.keyword)
            .do(
                onSuccess: { [weak self] qiitaItems in
                    guard let `self` = self else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    var contents = self.contentsSubject.value
                    let content = ListContents(offset: offset, type: .qiita, contents: qiitaItems)
                    contents.append(content)
                    contents.sort { $0.offset < $1.offset }
                    self.contentsSubject.accept(contents)
                },
                onError: { [weak self] error in
                    guard let `self` = self, let error = error as? APIError else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    if self.apiAccessCount.value == 0 {
                        self.errorAlertMessageSubject.accept(error.message)
                    }})
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }
}

extension ListViewModel: ListViewModelable {
    func showGithubView() {
        let viewController = R.storyboard.githubViewController.instantiateInitialViewController()!
        pushViewControllerSubject.accept(viewController)
    }

    func showQiitaView() {
        let viewController = R.storyboard.qiitaViewController.instantiateInitialViewController()!
        pushViewControllerSubject.accept(viewController)
    }
}
