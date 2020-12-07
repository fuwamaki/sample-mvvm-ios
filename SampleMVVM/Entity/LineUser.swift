//
//  LineUser.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/25.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import LineSDK

struct LineUser {
    let token: String
    let userId: String
    let displayName: String?
    let pictureUrl: URL?

    init(token: String, userId: String, displayName: String?, pictureUrl: URL?) {
        self.token = token
        self.userId = userId
        self.displayName = displayName
        self.pictureUrl = pictureUrl
    }

    // for unit test
    init(accessToken: String) {
        self.token = accessToken
        self.userId = ""
        self.displayName = nil
        self.pictureUrl = nil
    }
}
