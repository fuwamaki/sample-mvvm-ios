//
//  QiitaItemResponse.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct QiitaItemFetchResponse: ResponseProtocol {
    let items: [QiitaItem]
}

extension QiitaItemFetchResponse: Decodable {
    init(from decoder: Decoder) throws {
        var items: [QiitaItem] = []
        var unkeyedContainer = try decoder.unkeyedContainer()
        while !unkeyedContainer.isAtEnd {
            let item = try unkeyedContainer.decode(QiitaItem.self)
            items.append(item)
        }
        self.init(items: items)
    }
}

// Rootが配列型のJSONをCodableでマッピングしてくれる魔法のprotocol
private protocol Decodable {
    init(from decoder: Decoder) throws
}
