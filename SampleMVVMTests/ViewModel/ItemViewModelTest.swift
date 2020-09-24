//
//  ItemViewModelTest.swift
//  SampleMVVMTests
//
//  Created by yusaku maki on 2019/10/16.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import SampleMVVM

class ItemViewModelTest: XCTestCase {

    func testHandleRegisterBarButtonItem() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushViewController
                .drive(onNext: { viewController in
                    XCTAssertNotNil(viewController)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleRegisterBarButtonItem()
        }
        scheduler.start()
    }

    func testHandleTableItemButtonWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushViewController
                .drive(onNext: { viewController in
                    XCTAssertNotNil(viewController)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(300) {
            viewModel.handleTableItemButton(indexPath: IndexPath(row: 0, section: 0))
        }
        scheduler.start()
    }

    func testHandleTableItemButtonWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushViewController
                .drive(onNext: { viewController in
                    XCTAssertNil(viewController)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleTableItemButton(indexPath: nil)
        }
        scheduler.start()
    }

    func testFetchItemsWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        var itemsCount: Int = 0
        scheduler.scheduleAt(100) {
            viewModel.items
                .drive(onNext: { items in
                    XCTAssertEqual(items.count, itemsCount)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            itemsCount = 3
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testFetchItemsWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .failure)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.presentViewController
                .drive(onNext: { viewController in
                    XCTAssertNotNil(viewController)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testDeleteItemWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        var itemsCount: Int = 0
        scheduler.scheduleAt(100) {
            viewModel.items
                .drive(onNext: { items in
                    XCTAssertEqual(items.count, itemsCount)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            itemsCount = 3
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(300) {
            itemsCount = 2
            viewModel.deleteItem(indexPath: IndexPath(row: 0, section: 0))
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }
}

extension ItemViewModelTest {
    class MockAPIClient: APIClientable {

        var result: TestResultType
        var items: [Item] = [
            Item(id: 0, name: "test1", category: "fruit", price: 100),
            Item(id: 1, name: "test2", category: "goods", price: 200),
            Item(id: 2, name: "test3", category: "machine", price: 300)
        ]
        var githubRepositories: [GithubRepository]?
        var qiitaItem: [QiitaItem]?

        required init(result: TestResultType) {
            self.result = result
        }

        func fetchItems() -> Single<[Item]> {
            return Single<[Item]>.create(subscribe: { single in
                switch self.result {
                case .success:
                    single(.success(self.items))
                case .failure:
                    single(.error(APIError.unknownError))
                }
                return Disposables.create()
            })
        }

        func postItem(item: Item) -> Completable {
            return Completable.create(subscribe: { completable in
                switch self.result {
                case .success:
                    completable(.completed)
                case .failure:
                    completable(.error(APIError.unknownError))
                }
                return Disposables.create()
            })
        }

        func deleteItem(id: Int) -> Completable {
            return Completable.create(subscribe: { completable in
                switch self.result {
                case .success:
                    completable(.completed)
                case .failure:
                    completable(.error(APIError.unknownError))
                }
                return Disposables.create()
            })
        }

        func putItem(id: Int, item: Item) -> Completable {
            return Completable.create(subscribe: { completable in
                switch self.result {
                case .success:
                    completable(.completed)
                case .failure:
                    completable(.error(APIError.unknownError))
                }
                return Disposables.create()
            })
        }

        func fetchGithubRepositories(query: String) -> Single<[GithubRepository]> {
            return Single<[GithubRepository]>.create(subscribe: { single in
                switch self.result {
                case .success:
                    single(.success(self.githubRepositories ?? []))
                case .failure:
                    single(.error(APIError.unknownError))
                }
                return Disposables.create()
            })
        }

        func fetchQiitaItems(tag: String) -> Single<[QiitaItem]> {
            return Single<[QiitaItem]>.create(subscribe: { single in
                switch self.result {
                case .success:
                    single(.success(self.qiitaItem ?? []))
                case .failure:
                    single(.error(APIError.unknownError))
                }
                return Disposables.create()
            })
        }

        func lineLogin(viewController: UIViewController) -> Single<LineUser> {
            return Single<LineUser>.create(subscribe: { single in
                switch self.result {
                case .success:
                    single(.success(LineUser(accessToken: "testToken")))
                case .failure:
                    single(.error(APIError.unknownError))
                }
                return Disposables.create()
            })
        }
    }
}
