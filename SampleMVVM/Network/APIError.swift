//
//  APIError.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

enum APIError: Error {
    case customError(message: String)
    case nonDataError // 200なのにResponseがnilの場合
    case unauthorizedError // 401
    case notFoundError // 404
    case maintenanceError // 503
    case networkError
    case jsonParseError
    case unknownError

    var message: String {
        switch self {
        case .customError(let message):
            return message
        case .nonDataError:
            return R.string.localizable.error_non_data()
        case .unauthorizedError:
            return R.string.localizable.error_unauthorized()
        case .notFoundError:
            return R.string.localizable.error_not_found()
        case .maintenanceError:
            return R.string.localizable.error_maintenance()
        case .networkError:
            return R.string.localizable.error_network()
        default:
            return R.string.localizable.error_unknown()
        }
    }
}

enum MVVMError: Error {
    case jsonParseError

    var message: String {
        switch self {
        case .jsonParseError:
            return R.string.localizable.error_unknown()
        }
    }
}
