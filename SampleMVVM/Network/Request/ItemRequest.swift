//
//  ItemRequest.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Alamofire

struct ItemsFetchRequest: RequestProtocol {
    typealias Response = ItemsFetchResponse
    var url: String = Url.getItemsURL
    var method: HTTPMethod = .get
}

struct ItemPostRequest: RequestProtocol {
    typealias Response = ItemPostResponse
    var url: String = Url.postItemURL
    var method: HTTPMethod = .post
    var encoding: ParameterEncoding = JSONEncoding.default
}

struct ItemDeleteRequest: RequestProtocol {
    typealias Response = ItemDeleteResponse
    var id: Int
    var url: String {
        var urlComponents = URLComponents(string: Url.deleteItemURL)!
        urlComponents.queryItems = [URLQueryItem(name: "id", value: String(id))]
        return (urlComponents.url?.absoluteString)!
    }
    var method: HTTPMethod = .delete
}

struct ItemPutRequest: RequestProtocol {
    typealias Response = ItemPutResponse
    var url: String = Url.putItemURL
    var method: HTTPMethod = .put
    var encoding: ParameterEncoding = URLEncoding.default
    var parameters: Parameters?
}
