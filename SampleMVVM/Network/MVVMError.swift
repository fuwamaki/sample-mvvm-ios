//
//  MVVMError.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/12/07.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Foundation

enum MVVMError: Error {
    case jsonParseError

    var message: String {
        switch self {
        case .jsonParseError:
            return R.string.localizable.error_unknown()
        }
    }
}
