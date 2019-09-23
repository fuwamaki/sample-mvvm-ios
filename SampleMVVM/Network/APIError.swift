//
//  APIError.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

enum APIError: Error {
    case jsonParseError
    case invalidRequest
    case serverError
}
