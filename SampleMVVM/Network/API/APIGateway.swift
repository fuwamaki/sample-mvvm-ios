//
//  APIGateway.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

final class APIGateway: APIGatewayProtocol {

    private(set) var apiClient: APIClientable

    convenience init() {
        self.init(apiClient: APIClient())
    }

    init(apiClient: APIClientable) {
        self.apiClient = apiClient
    }
}
