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
    case github
    case qiita
    case other
}

class ListRealmEntity: Object, ItemRealmModelable {
    @objc dynamic var itemId: Int = 0
    @objc dynamic var keyword: String = ""
    @objc dynamic var typeString: String = ""

    var type: ListRealmType {
        switch typeString {
        case ListRealmType.github.rawValue:
            return .github
        case ListRealmType.qiita.rawValue:
            return .qiita
        default:
            return .other
        }
    }
}
