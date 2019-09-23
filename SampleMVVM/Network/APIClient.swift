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

    func call<T: RequestProtocol>(request: T, completion: @escaping (OriginalResult<T.Response, NSError>) -> Void) {
        let baseUrl = request.baseUrl
        let path = request.path
        let requestUrl = baseUrl + path
        let method = request.method
        let encoding = request.encoding
        let parameters = request.parameters
        let headers = request.headers

        Alamofire.request(requestUrl,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else { return }
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.Response.self, from: data)
                        completion(.success(result))
                    } catch {
                        let error = NSError(domain: "", code: 400, userInfo: nil)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error as NSError))
                }}
    }
}

protocol ResponseProtocol: Decodable {}

protocol RequestProtocol {
    associatedtype Response: ResponseProtocol
    var baseUrl: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var parameters: Alamofire.Parameters? { get }
    var headers: Alamofire.HTTPHeaders? { get }
}

extension RequestProtocol {
    var baseUrl: String {
        return "https://google.com"
    }

    var encoding: Alamofire.ParameterEncoding {
        return JSONEncoding.default
    }

    var parameters: Alamofire.Parameters? {
        return nil
    }

    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}
