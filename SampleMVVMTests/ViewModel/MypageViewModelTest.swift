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
            viewModel.presentViewController
                .drive(onNext: {
                    XCTAssertNotNil($0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleSettingBarButtonItem()
        }
        scheduler.start()
    }

    func testHandleAppleSigninButton() {
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = MypageViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.handleAppleSigninButton(
                viewController: MypageViewController())
        }
        scheduler.start()
    }

    func testHandleFailureAppleSignin() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = MypageViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.presentViewController
                .drive(onNext: {
                    XCTAssertNotNil($0)
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
            User(lineAccessToken: "test",
                 userId: "testUserId",
                 name: "testName",
                 birthday: Date(),
                 iconImageURL: nil,
                 iconImage: nil))
        scheduler.scheduleAt(100) {
            viewModel.pushViewController
                .drive(onNext: {
                    XCTAssertNotNil($0)
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
            viewModel.presentViewController
                .drive(onNext: {
                    XCTAssertNotNil($0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleEditButton()
        }
        scheduler.start()
    }
}
