//
//  QiitaUser.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct QiitaUser: Codable {
    let id: String
    let profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case profileImageUrl = "profile_image_url"
    }
}
