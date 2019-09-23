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

}
