//
//  UserDefaults+BoolDefaultSettable.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

protocol BoolDefaultSettable: KeyNamespaceable {
    associatedtype BoolKey: RawRepresentable
}

extension BoolDefaultSettable where BoolKey.RawValue == String {
    func set(_ value: Bool, forKey key: BoolKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    func remove(forKey key: BoolKey) {
        let key = namespaced(key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    @discardableResult
    func bool(forKey key: BoolKey) -> Bool? {
        let key = namespaced(key)
        return UserDefaults.standard.bool(forKey: key)
    }
}

extension UserDefaults: BoolDefaultSettable {
    enum BoolKey: String {
        case sample
    }
}
