//
//  APIClient+Item.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
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
                    single(.success(response.data))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        })
    }

    func postItemAPI(item: Item) -> Completable {
        return Completable.create(subscribe: { completable in
            self.postCall(body: item.postRequestData, request: ItemPostRequest()) { result in
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
