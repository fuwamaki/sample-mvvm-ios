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
    static let postItemURL = Url.baseItemURL + "/create"
    static let putItemURL = Url.baseItemURL + "/update"
    static let deleteItemURL = Url.baseItemURL + "/delete"
    static let githubBaseURL = "https://api.github.com"
    static let githubRepositoriesURL = Url.githubBaseURL + "/search/repositories"
}
