//
//  QiitaItemResponse.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct QiitaItemFetchResponse: ResponseProtocol {
    let items: [QiitaItem]
}
