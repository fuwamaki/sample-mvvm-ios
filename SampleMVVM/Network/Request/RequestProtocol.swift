//
//  RequestProtocol.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Alamofire

protocol RequestProtocol {
    associatedtype Response: ResponseProtocol
    var url: String { get }
    var method: Alamofire.HTTPMethod { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var parameters: Alamofire.Parameters? { get }
    var headers: Alamofire.HTTPHeaders? { get }
}

extension RequestProtocol {
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
