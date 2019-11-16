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
    var contents: Driver<[Int: [Listable]]> { get }
    var pushViewController: Driver<UIViewController> { get }
    func showGithubView()
    func showQiitaView()
}

final class ListViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)
    var viewWillAppear = PublishRelay<Void>()

    private var entitiesSubject = BehaviorRelay<[ListRealmEntity]>(value: [])

    private let contentsSubject = BehaviorRelay<[Int: [Listable]]>(value: [:])
    var contents: Driver<[Int: [Listable]]> {
        return contentsSubject.asDriver(onErrorJustReturn: [:])
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
                    case .failure:
                        print("Realm取得失敗")
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
                    case .other:
                        print("other")
                    default:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func fetchGithubRepositories(offset: Int, entity: ListRealmEntity) {
        apiClient.fetchGithubRepositories(query: entity.keyword)
            .subscribe(
                onSuccess: { [weak self] repositories in
                    self?.contentsSubject.accept([offset: repositories])
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.errorAlertMessageSubject.accept(error.message)})
            .disposed(by: disposeBag)
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
