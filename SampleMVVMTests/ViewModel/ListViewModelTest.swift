//
//  ListViewModelTest.swift
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

class ListViewModelTest: XCTestCase {

    func testShowGithubView() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = ListViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushScreen
                .drive(onNext: {
                    XCTAssertNotNil($0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.showGithubView()
        }
        scheduler.start()
    }

    func testShowQiitaView() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .failure)
        let viewModel = ListViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.pushScreen
                .drive(onNext: {
                    XCTAssertNotNil($0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.showQiitaView()
        }
        scheduler.start()
    }
}
