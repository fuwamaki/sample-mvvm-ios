//
//  Url.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct Url {
    static let baseItemURL = "https://item-server.herokuapp.com"
    static let getItemsURL = Url.baseItemURL + "/items"
    static var postItemURL = Url.baseItemURL + "/create"
    static var putItemURL = Url.baseItemURL + "/update"
    static var deleteItemURL = Url.baseItemURL + "/delete"
}
