//
//  MypageViewModelTest.swift
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

class MypageViewModelTest: XCTestCase {

    func testHandleSettingBarButtonItem() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = MypageViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .mypageActionSheet)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleSettingBarButtonItem()
        }
        scheduler.start()
    }

    func testHandleFailureAppleSignin() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = MypageViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .errorAlert(message: ""))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleFailureAppleSignin(APIError.unknownError)
        }
        scheduler.start()
    }

    func testHandleEditButtonWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = MypageViewModel(apiClient: apiClient)
        viewModel.user.accept(
            User(token: "test",
                 userId: "testUserId",
                 name: "testName",
                 birthday: Date(),
                 iconImageURL: nil,
                 iconImage: nil))
        scheduler.scheduleAt(100) {
            viewModel.pushScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .updateUser(user: User(token: "", userId: "", name: "", birthday: Date(), iconImageURL: nil, iconImage: nil)))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleEditButton()
        }
        scheduler.start()
    }

    func testHandleEditButtonWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = MypageViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .errorAlert(message: ""))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleEditButton()
        }
        scheduler.start()
    }
}
