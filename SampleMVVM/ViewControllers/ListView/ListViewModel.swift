//
//  ListViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ListViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var contentsSubject: BehaviorRelay<[ListContents]> { get }
    var contents: Driver<[ListContents]> { get }
    var pushScreen: Driver<Screen> { get }
    var presentScreen: Driver<Screen> { get }
    func showGithubView()
    func showQiitaView()
}

final class ListViewModel {

    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var viewWillAppear = PublishRelay<Void>()

    private var apiAccessCount = BehaviorRelay<Int>(value: 0)
    private var entitiesSubject = BehaviorRelay<[ListRealmEntity]>(value: [])

    var contentsSubject = BehaviorRelay<[ListContents]>(value: [])
    var contents: Driver<[ListContents]> {
        return contentsSubject.asDriver(onErrorJustReturn: [])
    }

    private var pushScreenSubject = PublishRelay<Screen>()
    var pushScreen: Driver<Screen> {
        return pushScreenSubject.asDriver(onErrorJustReturn: .other)
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
        viewWillAppear
            .subscribe(onNext: { [unowned self] _ in
                self.fetchItems()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        entitiesSubject
            .subscribe(onNext: { [unowned self] entities in
                entities.enumerated().forEach { offset, entity in
                    switch entity.type {
                    case .github:
                        let value = self.contentsSubject.value
                            .filter { $0.offset == offset }
                            .first
                        guard value?.sectionTitle != entity.keyword + " (github)" else { return }
                        self.fetchGithubRepositories(offset: offset, entity: entity)
                            .subscribe()
                            .disposed(by: self.disposeBag)
                    case .qiita:
                        let value = self.contentsSubject.value
                            .filter { $0.offset == offset }
                            .first
                        guard value?.sectionTitle != entity.keyword + " (qiita)" else { return }
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

    private func fetchItems() -> Completable {
        return Completable.create { completable in
            ItemRealmRepository<ListRealmEntity>.find()
                .subscribe(
                    onNext: { [weak self] entities in
                        self?.entitiesSubject.accept(entities)
                        completable(.completed)
                    },
                    onError: { error in
                        completable(.error(error))
                })
        }
    }

    private func fetchGithubRepositories(offset: Int, entity: ListRealmEntity) -> Completable {
        apiAccessCount.accept(apiAccessCount.value+1)
        let keyword = entity.keyword
        return apiClient.fetchGithubRepositories(query: entity.keyword)
            .do(
                onSuccess: { [weak self] repositories in
                    guard let `self` = self else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    let content = ListContents(offset: offset, type: .github, sectionTitle: keyword + " (github)", contents: repositories)
                    var contents = self.contentsSubject.value
                    contents.append(content)
                    contents.sort { $0.offset < $1.offset }
                    self.contentsSubject.accept(contents)
                },
                onError: { [weak self] error in
                    guard let `self` = self, let error = error as? APIError else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    if self.apiAccessCount.value == 0 {
                        self.presentScreenSubject.accept(.errorAlert(message: error.message))
                    }})
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    private func fetchQiitaItems(offset: Int, entity: ListRealmEntity) -> Completable {
        apiAccessCount.accept(apiAccessCount.value+1)
        let keyword = entity.keyword
        return apiClient.fetchQiitaItems(tag: entity.keyword)
            .do(
                onSuccess: { [weak self] qiitaItems in
                    guard let `self` = self else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    let content = ListContents(offset: offset, type: .qiita, sectionTitle: keyword + " (qiita)", contents: qiitaItems)
                    var contents = self.contentsSubject.value
                    contents.append(content)
                    contents.sort { $0.offset < $1.offset }
                    self.contentsSubject.accept(contents)
                },
                onError: { [weak self] error in
                    guard let `self` = self, let error = error as? APIError else { return }
                    self.apiAccessCount.accept(self.apiAccessCount.value-1)
                    if self.apiAccessCount.value == 0 {
                        self.presentScreenSubject.accept(.errorAlert(message: error.message))
                    }})
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }
}

// MARK: ListViewModelable
extension ListViewModel: ListViewModelable {
    func showGithubView() {
        pushScreenSubject.accept(.github)
    }

    func showQiitaView() {
        pushScreenSubject.accept(.qiita)
    }
}
