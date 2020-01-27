//
//  UserDefaults+DataDefaultSettable.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/27.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

protocol DataDefaultSettable: KeyNamespaceable {
    associatedtype DataKey: RawRepresentable
}

extension DataDefaultSettable where DataKey.RawValue == String {
    func set(_ value: Data, forKey key: DataKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    func remove(forKey key: DataKey) {
        let key = namespaced(key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    @discardableResult
    func data(forKey key: DataKey) -> Data? {
        let key = namespaced(key)
        return UserDefaults.standard.data(forKey: key)
    }
}

extension UserDefaults: DataDefaultSettable {
    enum DataKey: String {
        case iconImage
    }
}
