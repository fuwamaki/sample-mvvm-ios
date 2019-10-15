//
//  APIGateway+Item.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

extension APIGateway {
    func fetchItems() -> Single<[Item]> {
        return Single<[Item]>.create(subscribe: { [weak self] single in
            self?.apiClient.call(request: ItemsFetchRequest()) { result in
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
        return Completable.create(subscribe: { [weak self] completable in
            self?.apiClient.postCall(body: item.postRequestData, request: ItemPostRequest()) { result in
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
        return Completable.create(subscribe: { [weak self] completable in
            self?.apiClient.call(request: ItemDeleteRequest(id: id)) { result in
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
        return Completable.create(subscribe: { [weak self] completable in
            self?.apiClient.postCall(body: item.postRequestData, request: ItemPutRequest(id: id)) { result in
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
