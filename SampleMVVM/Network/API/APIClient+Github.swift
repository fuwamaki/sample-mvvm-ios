//
//  APIClient+Github.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/16.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa

extension APIClient {
    func fetchGithubRepositories(query: String) -> Single<[GithubRepository]> {
        return Single<[GithubRepository]>.create(subscribe: { single in
            self.get(request: GithubRepositoriesFetchRequest(query: query)) { result in
                switch result {
                case .success(let response):
                    single(.success(response?.items ?? []))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        })
    }
}
