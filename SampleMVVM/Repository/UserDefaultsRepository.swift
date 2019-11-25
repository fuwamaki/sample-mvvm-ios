//
//  UserDefaultsRepository.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

enum UserDefaultsIdType {
    case incrementListId
}

final class UserDefaultsRepository {
    static let shared = UserDefaultsRepository()
}

// MARK: auth token
extension UserDefaultsRepository {
    var authToken: String? {
        get {
            return UserDefaults.standard.string(forKey: .authToken)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .authToken)
        }
    }
}

// MARK: increment List ID
extension UserDefaultsRepository {
    var incrementListId: Int? {
        get {
            return UserDefaults.standard.integer(forKey: .incrementListId)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .incrementListId)
        }
    }

    func oneUp(type: UserDefaultsIdType) {
        switch type {
        case .incrementListId:
            guard let id = incrementListId else {
                incrementListId = 1
                return
            }
            incrementListId = id + 1
        }
    }
}
