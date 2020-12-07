//
//  UserDefaults+IntegerDefaultSettable.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

protocol IntegerDefaultSettable: KeyNamespaceable {
    associatedtype IntegerKey: RawRepresentable
}

extension IntegerDefaultSettable where IntegerKey.RawValue == String {
    func set(_ value: Int, forKey key: IntegerKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    func remove(forKey key: IntegerKey) {
        let key = namespaced(key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    @discardableResult
    func integer(forKey key: IntegerKey) -> Int? {
        let key = namespaced(key)
        return UserDefaults.standard.integer(forKey: key)
    }
}

extension UserDefaults: IntegerDefaultSettable {
    enum IntegerKey: String {
        case incrementListId
        case userType
    }
}
