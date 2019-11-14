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
            return "申し訳ありません、データがありませんでした。"
        case .unauthorizedError:
            return "ユーザーセッションの有効期限が切れたため、再度ログインしてください。"
        case .notFoundError:
            return "申し訳ありません、データが見つかりませんでした。"
        case .maintenanceError:
            return "メンテナンス中です。終了までしばらくお待ちください。"
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
