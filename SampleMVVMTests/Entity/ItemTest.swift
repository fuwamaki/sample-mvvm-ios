//
//  ItemTest.swift
//  SampleMVVMTests
//
//  Created by yusaku maki on 2020/09/24.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import XCTest
@testable import SampleMVVM

class ItemTest: XCTestCase {

    func testItem() {
        let item = Item(id: nil,
                        name: "testName",
                        category: "testCategory",
                        price: 100)
        XCTAssertNotNil(item.postRequestData)
        XCTAssertNotNil(item.dictionary)
    }
}
