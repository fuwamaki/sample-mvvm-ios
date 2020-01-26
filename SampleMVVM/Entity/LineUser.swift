//
//  LineUser.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/25.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import LineSDK

struct LineUser {
    let accessToken: String
    let userId: String?
    let displayName: String?
    let pictureURL: URL?

    init(loginResult: LoginResult) {
        self.accessToken = loginResult.accessToken.value
        self.userId = loginResult.userProfile?.userID
        self.displayName = loginResult.userProfile?.displayName
        self.pictureURL = loginResult.userProfile?.pictureURL
    }
}
