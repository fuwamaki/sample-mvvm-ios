//
//  APIClient.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

struct APIClient {
    func call<T: RequestProtocol>(request: T, completion: @escaping (OriginalResult<T.Response, Error>) -> Void) {
        Alamofire.request(request.url,
                          method: request.method,
                          parameters: request.parameters,
                          encoding: request.encoding,
                          headers: request.headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else {
                            completion(.failure(APIError.jsonParseError))
                            return
                        }
                        let result = try JSONDecoder().decode(T.Response.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(APIError.jsonParseError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }}
    }

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
