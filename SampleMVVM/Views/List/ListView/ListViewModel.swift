//
//  ListViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

import Foundation
final class SwiftScriptRunner {
    private var count = 0
    private let runLoop = RunLoop.current

    init() {}

    func lock() {
        count += 1
    }

    func unlock() {
        count -= 1
    }

    func wait() {
        while count > 0 &&
            runLoop.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1)) {
                // Run, run, run
        }
    }
}

protocol ListViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var viewDidAppear: PublishRelay<Void> { get }
    var contents: Driver<[Int: [Listable]]> { get }
    var pushViewController: Driver<UIViewController> { get }
    func showGithubView()
    func showQiitaView()
}

final class ListViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)
    var viewWillAppear = PublishRelay<Void>()
    var viewDidAppear = PublishRelay<Void>()

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
//        viewWillAppear
//            .subscribe(onNext: { [weak self] _ in
//                RealmRepository<ListRealmEntity>.find { [weak self] result in
//                    switch result {
//                    case .success(let entities):
//                        self?.entitiesSubject.accept(entities)
//                        print(entities)
//                    case .failure:
//                        print("Realm取得失敗")
//                    }
//                }
//            })
//            .disposed(by: disposeBag)

        viewDidAppear
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
                    let runner = SwiftScriptRunner()
                    runner.lock()
                    switch entity.type {
                    case .github:
                        self.fetchGithubRepositories(offset: offset, entity: entity)
                            .subscribe(onCompleted: {
                                runner.unlock()
                            })
                            .disposed(by: self.disposeBag)
                    case .other:
                        print("other")
                    default:
                        break
                    }
                    runner.wait()
                }
            })
            .disposed(by: disposeBag)
    }

    private func fetchGithubRepositories(offset: Int, entity: ListRealmEntity) -> Completable {
        apiClient.fetchGithubRepositories(query: entity.keyword)
            .do(
                onSuccess: { [weak self] repositories in
                    guard var contents = self?.contentsSubject.value else { return }
                    contents.updateValue(repositories, forKey: offset)
                    self?.contentsSubject.accept(contents)
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.errorAlertMessageSubject.accept(error.message)})
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
