//
//  MockAPIClient.swift
//  SampleMVVMTests
//
//  Created by yusaku maki on 2020/09/28.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import SampleMVVM

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
