//
//  GithubRepositoryRequest.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Alamofire

struct GithubRepositoriesFetchRequest: RequestProtocol {
    typealias Response = GithubRepositoriesFetchResponse
    var query: String
    var url: String {
        var urlComponents = URLComponents(string: Url.githubRepositoriesURL)!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: String(query))]
        return (urlComponents.url?.absoluteString)!
    }
    var method: HTTPMethod = .get
}
