//
//  APIError.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

enum APIError: Error {
    case networkError
    case jsonParseError
    case invalidRequest
    case serverError

    var message: String {
        switch self {
        case .networkError:
            return "通信エラーが発生しました。電波の良い所で再度お試しください。"
        default:
            return "不具合が発生しました。お手数ですが時間をおいてもう一度お試しください。"
        }
    }
}

enum MVVMError: Error {
    case jsonParseError

    var message: String {
        switch self {
        case .jsonParseError:
            return "不具合が発生しました。お手数ですが時間をおいてもう一度お試しください。"
        }
    }
}
