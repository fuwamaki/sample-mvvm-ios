//
//  ItemAPIGatewayTest.swift
//  SampleMVVMTests
//
//  Created by yusaku maki on 2019/10/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import SampleMVVM

class ItemAPIGatewayTest: XCTestCase {

    private let disposeBag = DisposeBag()

    func testFetchItems() {
        let mockResponse = ItemsFetchResponse(data: [Item(id: nil, name: "test", category: "test", price: 100)])
        let apiClient: APIClientable = MockAPIClient(result: .success, mockResponse: mockResponse)
        let apiGateway: APIGatewayProtocol = APIGateway(apiClient: apiClient)
        apiGateway.fetchItems()
            .do(
                onSuccess: { items in
                    XCTAssertEqual(items.count, 1)
            },
                onError: { _ in
                    fatalError()})
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ItemAPIGatewayTest {
    class MockAPIClient: APIClientable {

        var result: TestResultType
        var mockResponse: ResponseProtocol

        required init(result: TestResultType, mockResponse: ResponseProtocol = TestResponse()) {
            self.result = result
            self.mockResponse = mockResponse
        }

        func call<T>(request: T, completion: @escaping (Result<T.Response?, Error>) -> Void) where T: RequestProtocol {
            switch result {
            case .success:
                let response: T.Response = mockResponse as! T.Response
                completion(.success(response))
            case .failure:
                completion(.failure(NSError(domain: "test", code: 0, userInfo: nil)))
            }
        }

        func postCall<T>(body: Data, request: T, completion: @escaping (Result<T.Response?, Error>) -> Void) where T: RequestProtocol {
            switch result {
            case .success:
                completion(.success(nil))
            case .failure:
                completion(.failure(NSError(domain: "test", code: 0, userInfo: nil)))
            }
        }
    }
}
