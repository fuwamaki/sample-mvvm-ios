//
//  Alamofire+DataRequest.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/29.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Alamofire

// MARK: Logging
extension DataRequest {
    public func log() -> Self {
        return logRequest().logResponse()
    }
}

// MARK: Request logging
extension DataRequest {
    public func logRequest() -> Self {
        guard let method = request?.httpMethod,
            let url = request?.url?.absoluteString else { return self }
        debugPrint("Request: method - \(method), url - \(url)")
        return self
    }
}

// MARK: Response logging
extension DataRequest {
    public func logResponse() -> Self {
        return response { response in
            guard let code = response.response?.statusCode,
                let url = response.request?.url?.absoluteString else { return }
            debugPrint("Response: statusCode - \(code), url - \(url)")
        }
    }
}
