//
//  RequestProtocol.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Alamofire

// memo: Alamofireでbody,queryの設定をしようとすると必ずバグるので、使わないことに。
protocol RequestProtocol {
    associatedtype Response: ResponseProtocol
    var url: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var headers: Alamofire.HTTPHeaders? { get }
}

extension RequestProtocol {
    var parameters: Alamofire.Parameters? {
        return nil
    }

    var encoding: Alamofire.ParameterEncoding {
        return URLEncoding.default
    }

    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}
