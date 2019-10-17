//
//  APIClient.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import Alamofire

struct APIClient: APIClientable {

    private var client: Alamofire.SessionManager = {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        // memo: headerはこうやって指定する
        defaultHeaders["Content-Type"] = "application/json"
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.httpAdditionalHeaders = defaultHeaders
        return Alamofire.SessionManager(configuration: configuration)
    }()

    func call<T: RequestProtocol>(request: T, completion: @escaping (OriginalResult<T.Response?, Error>) -> Void) {
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

    func testCall<T: RequestProtocol>(request: T, completion: @escaping (OriginalResult<T.Response?, Error>) -> Void) {
        client.request(request.url,
                       method: request.method,
                       parameters: request.parameters)
            .response { response in // memo: post時はresponseDataがない場合に.responseJSONを使えないらしい
                if let error = response.error {
                    completion(.failure(error))
                } else {
                    switch response.response?.statusCode {
                    case 200, 201, 202, 203, 204:
                        completion(.success(nil))
                    default:
                        completion(.failure(APIError.jsonParseError))
                    }
                }}
    }

    func postCall<T: RequestProtocol>(body: Data, request: T, completion: @escaping (OriginalResult<T.Response?, Error>) -> Void) {
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
