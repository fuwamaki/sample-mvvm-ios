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
    // line=0, apple=1
    var userType: Int? {
        get {
            return UserDefaults.standard.integer(forKey: .userType)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .userType)
        }
    }

    var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: .userId)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .userId)
        }
    }

    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: .token)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .token)
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

    var iconImage: Data? {
        get {
            return UserDefaults.standard.data(forKey: .iconImage)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: .iconImage)
        }
    }

    func fetchUser() -> User? {
        if let userTypeInt = userType,
           let userType = UserType(rawValue: userTypeInt),
           let token = token,
           let userId = userId,
           let birthdayString = birthday,
           let name = name,
           let birthday = DateFormat.yyyyMMdd.date(from: birthdayString) {
            return User(userType: userType,
                        token: token,
                        userId: userId,
                        name: name,
                        birthday: birthday,
                        iconImage: iconImage)
        } else { return nil }
    }

    // login
    func createUser(user: User) {
        userType = user.userType.rawValue
        userId = user.userId
        token = user.token
        name = user.name
        birthday = DateFormat.yyyyMMdd.string(from: user.birthday)
        iconImage = user.iconImage
    }

    // logout
    func removeUser() {
        UserDefaults.standard.remove(forKey: .userId)
        UserDefaults.standard.remove(forKey: .token)
        UserDefaults.standard.remove(forKey: .name)
        UserDefaults.standard.remove(forKey: .birthday)
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
