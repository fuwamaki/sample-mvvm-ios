//
//  GithubRepository.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

protocol Listable {}

struct GithubRepository: Codable, Listable {
    let fullName: String
    let stargazersCount: Int
    let htmlUrl: String
    let owner: GithubRepositoryOwner

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case htmlUrl = "html_url"
        case owner
    }

    init(fullName: String, stargazersCount: Int, htmlUrl: String, owner: GithubRepositoryOwner) {
        self.fullName = fullName
        self.stargazersCount = stargazersCount
        self.htmlUrl = htmlUrl
        self.owner = owner
    }
}
