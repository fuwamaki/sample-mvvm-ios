//
//  UserRealmEntity.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/26.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealmEntity: Object, UserRealmModelable {
    @objc dynamic var userId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var birthday: Date = Date()
    @objc dynamic var iconImageUrl: String = ""
}
