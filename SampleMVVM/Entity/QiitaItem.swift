//
//  QiitaItem.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct QiitaItem: Codable {
    let id: String
    let title: String
    let likesCount: Int
    let url: String
    let user: QiitaUser

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case likesCount = "likes_count"
        case url
        case user
    }
}
