//
//  ListContents.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/17.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

struct ListContents {
    let offset: Int
    let type: ListRealmType
    let sectionTitle: String
    let contents: [Listable]
}
