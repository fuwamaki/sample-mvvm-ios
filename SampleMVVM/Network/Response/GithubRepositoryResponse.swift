//
//  GithubRepositoryResponse.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct GithubRepositoriesFetchResponse: ResponseProtocol {
    let items: [GithubRepository]
}
