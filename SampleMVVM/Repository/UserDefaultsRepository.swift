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

// MARK: auth token（auth tokenが必要なAPI用。今回は不要だけど。）
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

// MARK: user
extension UserDefaultsRepository {
    var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: .userId)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .userId)
        }
    }

    var lineAccessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: .lineAccessToken)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .lineAccessToken)
        }
    }

    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: .name)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .name)
        }
    }

    var birthday: String? {
        get {
            return UserDefaults.standard.string(forKey: .birthday)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .birthday)
        }
    }

    var pictureUrl: URL? {
        get {
            return UserDefaults.standard.URL(forKey: .pictureUrl)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .pictureUrl)
        }
    }

    var iconImage: Data? {
        get {
            return UserDefaults.standard.data(forKey: .iconImage)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .iconImage)
        }
    }

    func removeUser() {
        UserDefaults.standard.remove(forKey: .userId)
        UserDefaults.standard.remove(forKey: .lineAccessToken)
        UserDefaults.standard.remove(forKey: .name)
        UserDefaults.standard.remove(forKey: .birthday)
        UserDefaults.standard.remove(forKey: .pictureUrl)
        UserDefaults.standard.remove(forKey: .iconImage)
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
