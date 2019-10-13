//
//  APIClient.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import Alamofire

struct APIClient {
    func call<T: RequestProtocol>(request: T, completion: @escaping (OriginalResult<T.Response, Error>) -> Void) {
        Alamofire.request(request.url, method: request.method)
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

    func postCall<T: RequestProtocol>(body: Data, request: T, completion: @escaping (OriginalResult<T.Response, Error>) -> Void) {
        var urlRequest = URLRequest(url: URL(string: request.url)!)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        Alamofire.request(urlRequest)
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
}
