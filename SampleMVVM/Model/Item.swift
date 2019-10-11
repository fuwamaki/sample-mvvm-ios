//
//  Item.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct RequestItem: Codable {
    let item: Item
}

struct Item: Codable {
    let id: Int?
    let name: String
    let category: String
    let price: Int

    var requestData: Data {
        let requestItem = RequestItem(item: self)
        guard let data = try? JSONEncoder().encode(requestItem) else {
            fatalError(MVVMError.jsonParseError.localizedDescription)
        }
        return data
    }

    // [String: Any]のDictionary型Model
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            fatalError(MVVMError.jsonParseError.localizedDescription)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            return json
        } catch {
            fatalError("json parse error")
        }
    }

    var postRequestDictionary: [String: Any] {
        struct PostRequest: Codable {
            let item: Item
        }
        let request = PostRequest(item: self)
        guard let data = try? JSONEncoder().encode(request) else {
            fatalError(MVVMError.jsonParseError.localizedDescription)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            return json
        } catch {
            fatalError("json parse error")
        }
    }
}
