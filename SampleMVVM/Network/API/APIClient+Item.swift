//
//  APIClient+Item.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/16.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension APIClient {
    func fetchItems() -> Single<[Item]> {
        return Single<[Item]>.create(subscribe: { single in
            self.call(request: ItemsFetchRequest()) { result in
                switch result {
                case .success(let response):
                    single(.success(response?.data ?? []))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        })
    }

    func postItem(item: Item) -> Completable {
        return Completable.create(subscribe: { completable in
            self.testCall(request: ItemPostRequest(parameters: ["item": item.dictionary])) { result in
                switch result {
                case .success:
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create()
        })
    }

    func deleteItem(id: Int) -> Completable {
        return Completable.create(subscribe: { completable in
            self.call(request: ItemDeleteRequest(id: id)) { result in
                switch result {
                case .success:
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create()
        })
    }

    func putItem(id: Int, item: Item) -> Completable {
        return Completable.create(subscribe: { completable in
            self.postCall(body: item.postRequestData, request: ItemPutRequest(id: id)) { result in
                switch result {
                case .success:
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create()
        })
    }
}
