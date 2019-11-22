//
//  APIClient.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

final class APIClient: APIClientable {

    private var client: Alamofire.SessionManager?

    private func createAPIClient(header: [String: String]?) -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        if let header = header {
            var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            // memo: headerはこうやって指定する
            header.forEach { key, value in
                defaultHeaders[key] = value
            }
            configuration.httpAdditionalHeaders = defaultHeaders
        }
        return Alamofire.SessionManager(configuration: configuration)
    }

    private var isNetworkConnect: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return isReachable && !needsConnection
    }

    func call<T: RequestProtocol>(request: T, completion: @escaping (OriginalResult<T.Response?, APIError>) -> Void) {
        guard isNetworkConnect else {
            completion(.failure(APIError.networkError))
            return
        }
        if client == nil {
            client = createAPIClient(header: ["Content-Type": "Content-Type"])
        }
        client?.request(request.url,
                          method: request.method,
                          parameters: request.parameters,
                          encoding: request.encoding,
                          headers: request.headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else {
                            completion(.failure(APIError.nonDataError))
                            return
                        }
                        let result = try JSONDecoder().decode(T.Response.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(APIError.jsonParseError))
                    }
                case .failure(let error as NSError):
                    switch error.code {
                    case 401:
                        completion(.failure(.unauthorizedError))
                    case 404:
                        completion(.failure(.notFoundError))
                    case 503:
                        completion(.failure(.maintenanceError))
                    default:
                        completion(.failure(.unknownError))
                    }
                }}
    }

    func writeCall<T: RequestProtocol>(request: T, completion: @escaping (OriginalResult<T.Response?, APIError>) -> Void) {
        guard isNetworkConnect else {
            completion(.failure(APIError.networkError))
            return
        }
        let client = createAPIClient(header: request.headers)
        client.request(request.url,
                        method: request.method,
                        parameters: request.parameters,
                        encoding: request.encoding,
                        headers: request.headers)
            .response { response in
                if let error = response.error as NSError? {
                    switch error.code {
                    case 401:
                        completion(.failure(.unauthorizedError))
                    case 404:
                        completion(.failure(.notFoundError))
                    case 503:
                        completion(.failure(.maintenanceError))
                    default:
                        completion(.failure(.unknownError))
                    }
                } else {
                    switch response.response?.statusCode {
                    case .some(let code) where 200 <= code && code < 300:
                        completion(.success(nil))
                    default:
                        completion(.failure(APIError.unknownError))
                    }
                }
        }
    }

    // TODO: 消す
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
