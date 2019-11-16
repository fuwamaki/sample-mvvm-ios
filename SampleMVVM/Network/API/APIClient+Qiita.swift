//
//  APIClient+Qiita.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

extension APIClient {
    func fetchQiitaItems(tag: String) -> Single<[QiitaItem]> {
        return Single<[QiitaItem]>.create { single in
            self.get(request: QiitaItemsFetchRequest(tag: tag)) { result in
                switch result {
                case .success(let response):
                    single(.success(response?.items ?? []))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
