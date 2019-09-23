//
//  ItemResponse.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct ItemsFetchResponse: ResponseProtocol {
    let data: [Item]
}

struct ItemPostResponse: ResponseProtocol {
    let item: Item
}

struct ItemDeleteResponse: ResponseProtocol {
}

struct ItemPutResponse: ResponseProtocol {
}