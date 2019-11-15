//
//  ListRealmEntity.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import RealmSwift

enum ListRealmType: String {
    case github = "github"
    case qiita = "qiita"
}

class ListRealmEntity: Object, RealmModelable {
    @objc dynamic var itemId: Int = 0
    @objc dynamic var keyword: String = ""
    @objc dynamic var type: String = ""
}
