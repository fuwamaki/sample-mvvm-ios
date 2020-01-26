//
//  UserDefaults+URLDefaultSettable.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

protocol URLDefaultSettable: KeyNamespaceable {
    associatedtype URLKey: RawRepresentable
}

extension URLDefaultSettable where URLKey.RawValue == String {
    func set(_ value: URL, forKey key: URLKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    @discardableResult
    func URL(forKey key: URLKey) -> URL? {
        let key = namespaced(key)
        return UserDefaults.standard.url(forKey: key)
    }
}

extension UserDefaults: URLDefaultSettable {
    enum URLKey: String {
        case pictureUrl
    }
}
