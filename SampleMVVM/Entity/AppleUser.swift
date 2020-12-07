//
//  AppleUser.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/12/07.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Foundation

struct AppleUser {
    let token: String
    let userId: String
    let name: String

    init(token: String, userId: String, givenName: String?, familyName: String?) {
        self.token = token
        self.userId = userId
        self.name = (givenName ?? "") + (familyName ?? "")
    }
}
