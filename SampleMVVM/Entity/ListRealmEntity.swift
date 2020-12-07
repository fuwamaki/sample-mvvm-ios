//
//  ListRealmEntity.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation
import RealmSwift

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

    static func make(keyword: String, type: ListRealmType) -> ListRealmEntity {
        let entity = ListRealmEntity()
        entity.itemId = UserDefaultsRepository.shared.incrementListId ?? 0
        entity.keyword = keyword
        entity.typeString = type.rawValue
        return entity
    }
}
