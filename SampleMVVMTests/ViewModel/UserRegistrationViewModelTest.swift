//
//  UserRegistrationViewModelTest.swift
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

class UserRegistrationViewModelTest: XCTestCase {

    func testHandleFailureAppleSignin() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = UserRegistrationViewModel(
            type: .create(lineUser: LineUser(accessToken: "token")))
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .imagePicker)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleChangeImageButton()
        }
        scheduler.start()
    }

    func testHandleSubmitButtonWithEmpty() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = UserRegistrationViewModel(
            type: .create(lineUser: LineUser(accessToken: "token")))
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .errorAlert(message: ""))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleSubmitButton()
        }
        scheduler.start()
    }

    func testHandleSubmitButtonWithCreate() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = UserRegistrationViewModel(
            type: .create(lineUser: LineUser(accessToken: "token")))
        viewModel.name.accept("testName")
        viewModel.birthday.accept(Date())
        scheduler.scheduleAt(100) {
            viewModel.presentScreen
                .drive(onNext: {
                    XCTAssertTrue($0 == .errorAlertAndDismiss(message: ""))
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleSubmitButton()
        }
        scheduler.start()
    }

    func testHandleSubmitButtonWithUpdate() {
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = UserRegistrationViewModel(
            type: .update(user: User(lineAccessToken: "token", userId: "userId", name: "name", birthday: Date(), iconImageURL: nil, iconImage: nil)))
        viewModel.name.accept("testName")
        viewModel.birthday.accept(Date())
        scheduler.scheduleAt(100) {
            viewModel.handleSubmitButton()
        }
        scheduler.start()
    }
}
