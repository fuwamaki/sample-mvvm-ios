//
//  ItemViewModelTest.swift
//  SampleMVVMTests
//
//  Created by yusaku maki on 2019/10/16.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import SampleMVVM

class ItemViewModelTest: XCTestCase {

    func testHandleRegisterBarButtonItem() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .itemRegister)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleRegisterBarButtonItem()
        }
        scheduler.start()
    }

    func testHandleTableItemButtonWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .itemUpdate(item: Item(id: nil, name: "", category: "", price: 0)))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(300) {
            viewModel.handleTableItemButton(indexPath: IndexPath(row: 0, section: 0))
        }
        scheduler.start()
    }

    func testHandleTableItemButtonWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .itemUpdate(item: Item(id: nil, name: "", category: "", price: 0)))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleTableItemButton(indexPath: nil)
        }
        scheduler.start()
    }

    func testFetchItemsWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        var itemsCount: Int = 0
        scheduler.scheduleAt(100) {
            viewModel.items
                .drive(onNext: { items in
                    XCTAssertEqual(items.count, itemsCount)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            itemsCount = 3
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testFetchItemsWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .failure)
        let viewModel = ItemViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .errorAlert(message: ""))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testDeleteItemWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemViewModel(apiClient: apiClient)
        var itemsCount: Int = 0
        scheduler.scheduleAt(100) {
            viewModel.items
                .drive(onNext: { items in
                    XCTAssertEqual(items.count, itemsCount)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            itemsCount = 3
            viewModel.fetchItems()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(300) {
            itemsCount = 2
            viewModel.deleteItem(indexPath: IndexPath(row: 0, section: 0))
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }
}
