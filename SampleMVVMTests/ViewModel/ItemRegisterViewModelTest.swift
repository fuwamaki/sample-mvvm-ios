//
//  ItemRegisterViewModelTest.swift
//  SampleMVVMTests
//
//  Created by yusaku maki on 2020/09/24.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import SampleMVVM

class ItemRegisterViewModelTest: XCTestCase {

    func testValid() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemRegisterViewModel(apiClient: apiClient)
        var isValid: Bool = false
        var isAllValid: Bool = false
        scheduler.scheduleAt(100) {
            viewModel.nameValid
                .subscribe(onNext: {
                    XCTAssertEqual($0, isValid)
                })
                .disposed(by: disposeBag)
            viewModel.categoryValid
                .subscribe(onNext: {
                    XCTAssertEqual($0, isValid)
                })
                .disposed(by: disposeBag)
            viewModel.priceValid
                .subscribe(onNext: {
                    XCTAssertEqual($0, isValid)
                })
                .disposed(by: disposeBag)
            viewModel.allFieldsValid
                .subscribe(onNext: {
                    XCTAssertEqual($0, isAllValid)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isValid.toggle()
            viewModel.nameText.accept("testName")
            viewModel.categoryText.accept("testCategory")
            isAllValid.toggle()
            viewModel.priceText.accept("100")
        }
        scheduler.start()
    }

    func testSetupItem() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemRegisterViewModel(apiClient: apiClient)
        let sampleItem = Item(id: 0, name: "testName", category: "testCategory", price: 100)
        viewModel.editItem = sampleItem
        var name: String?
        var category: String?
        var price: String?
        scheduler.scheduleAt(100) {
            viewModel.nameText
                .subscribe(onNext: {
                    XCTAssertEqual($0, name)
                })
                .disposed(by: disposeBag)
            viewModel.categoryText
                .subscribe(onNext: {
                    XCTAssertEqual($0, category)
                })
                .disposed(by: disposeBag)
            viewModel.priceText
                .subscribe(onNext: {
                    XCTAssertEqual($0, price)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            name = sampleItem.name
            category = sampleItem.category
            price = String(sampleItem.price)
            viewModel.setupItem()
        }
        scheduler.start()
    }

    func testHandleRegisterButtonWhenRegisterModeWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemRegisterViewModel(apiClient: apiClient)
        var isCompleted: Bool = false
        viewModel.nameText.accept("testName")
        viewModel.categoryText.accept("testCategory")
        viewModel.priceText.accept("100")
        scheduler.scheduleAt(100) {
            viewModel.completedSubject
                .subscribe(onNext: {
                    XCTAssertEqual(isCompleted, $0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isCompleted.toggle()
            viewModel.handleRegisterButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleRegisterButtonWhenRegisterModeWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .failure)
        let viewModel = ItemRegisterViewModel(apiClient: apiClient)
        var isCompleted: Bool = false
        viewModel.nameText.accept("testName")
        viewModel.categoryText.accept("testCategory")
        viewModel.priceText.accept("100")
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .errorAlert(message: ""))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isCompleted.toggle()
            viewModel.handleRegisterButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleRegisterButtonWhenUpdateModeWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ItemRegisterViewModel(apiClient: apiClient)
        var isCompleted: Bool = false
        viewModel.editItem = Item(id: 0, name: "testName", category: "testCategory", price: 100)
        viewModel.nameText.accept("testNewName")
        viewModel.categoryText.accept("testNewCategory")
        viewModel.priceText.accept("100")
        scheduler.scheduleAt(100) {
            viewModel.completedSubject
                .subscribe(onNext: {
                    XCTAssertEqual(isCompleted, $0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isCompleted.toggle()
            viewModel.handleRegisterButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleRegisterButtonWhenUpdateModeWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .failure)
        let viewModel = ItemRegisterViewModel(apiClient: apiClient)
        var isCompleted: Bool = false
        viewModel.editItem = Item(id: 0, name: "testName", category: "testCategory", price: 100)
        viewModel.nameText.accept("testNewName")
        viewModel.categoryText.accept("testNewCategory")
        viewModel.priceText.accept("100")
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .errorAlert(message: ""))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isCompleted.toggle()
            viewModel.handleRegisterButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }
}
