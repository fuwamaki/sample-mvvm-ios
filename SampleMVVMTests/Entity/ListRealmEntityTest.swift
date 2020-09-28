//
//  ListRealmEntityTest.swift
//  SampleMVVMTests
//
//  Created by yusaku maki on 2020/09/28.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import XCTest
@testable import SampleMVVM

class ListRealmEntityTest: XCTestCase {

    func testListRealmEntity() {
        let entity = ListRealmEntity()
        XCTAssertEqual(entity.type, .other)
        entity.typeString = ListRealmType.github.rawValue
        XCTAssertEqual(entity.type, .github)
        entity.typeString = ListRealmType.qiita.rawValue
        XCTAssertEqual(entity.type, .qiita)

        XCTAssertNotNil(ListRealmEntity.make(keyword: "test", type: .qiita))
    }
}
