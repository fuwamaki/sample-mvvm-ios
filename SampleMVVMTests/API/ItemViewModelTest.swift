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

    func testShowRegister() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        viewModel.fetchItems()
            .subscribe()
            .disposed(by: disposeBag)
        scheduler.scheduleAt(100) {
            viewModel.pushRegister
            .drive(onNext: { viewController in
                XCTAssertNotNil(viewController)})
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.showRegister(indexPath: IndexPath(row: 0, section: 0))
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

        required init(result: TestResultType) {
            self.result = result
        }

        func fetchItems() -> Single<[Item]> {
            return Single<[Item]>.create(subscribe: { single in
                switch self.result {
                case .success:
                    single(.success(self.items))
                case .failure:
                    single(.error(NSError(domain: "test", code: 0, userInfo: nil)))
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
                    completable(.error(NSError(domain: "test", code: 0, userInfo: nil)))
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
                    completable(.error(NSError(domain: "test", code: 0, userInfo: nil)))
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
                    completable(.error(NSError(domain: "test", code: 0, userInfo: nil)))
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
                    single(.error(NSError(domain: "test", code: 0, userInfo: nil)))
                }
                return Disposables.create()
            })
        }
    }
}
