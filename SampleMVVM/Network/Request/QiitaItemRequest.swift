//
//  QiitaItemRequest.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Alamofire

struct QiitaItemsFetchRequest: RequestProtocol {
    typealias Response = QiitaItemFetchResponse
    var tag: String
    var url: String {
        let value = Url.qiitaItemsParTagURL + "/" + tag + "/items"
        return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    var method: HTTPMethod = .get
}
