//
//  KeyNamespaceable.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

protocol KeyNamespaceable {
    func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {
    func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return "\(Self.self).\(key.rawValue)"
    }
}
