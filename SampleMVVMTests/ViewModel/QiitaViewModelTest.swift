//
//  QiitaViewModelTest.swift
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

class QiitaViewModelTest: XCTestCase {

    func testValid() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = QiitaViewModel(apiClient: apiClient)
        var isValid: Bool = false
        scheduler.scheduleAt(100) {
            viewModel.searchQueryValid
                .subscribe(onNext: {
                    XCTAssertEqual($0, isValid)
                })
                .disposed(by: disposeBag)
            viewModel.searchedQueryValid
                .subscribe(onNext: {
                    XCTAssertEqual($0, isValid)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isValid.toggle()
            viewModel.searchQuery.accept("testQuery")
            viewModel.searchedQuery.accept("testQuery")
        }
        scheduler.start()
    }

    func testHandleSearchButtonWithEmpty() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = QiitaViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.handleSearchButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleSearchButtonWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        apiClient.qiitaItems = [
            QiitaItem(id: "testId",
                      title: "testTitle",
                      likesCount: 100,
                      url: "https://google.com",
                      user: QiitaUser(id: "testId2",
                                      profileImageUrl: "https://google.com"))]
        let viewModel = QiitaViewModel(apiClient: apiClient)
        viewModel.searchQuery.accept("test")
        var count: Int = 0
        scheduler.scheduleAt(100) {
            viewModel.qiitaItems
                .drive(onNext: {
                    XCTAssertEqual($0.count, count)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            count = 1
            viewModel.handleSearchButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleSearchButtonWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .failure)
        let viewModel = QiitaViewModel(apiClient: apiClient)
        viewModel.searchQuery.accept("test")
        scheduler.scheduleAt(100) {
            viewModel.presentViewController
                .drive(onNext: {
                    XCTAssertNotNil($0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.handleSearchButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleFavoriteBarButtonWithEmpty() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = QiitaViewModel(apiClient: apiClient)
        scheduler.scheduleAt(100) {
            viewModel.handleFavoriteBarButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleFavoriteBarButtonWithSuccess() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        let viewModel = QiitaViewModel(apiClient: apiClient)
        viewModel.searchedQuery.accept("test")
        var isCompleted: Bool = false
        scheduler.scheduleAt(100) {
            viewModel.completedSubject
                .subscribe(onNext: {
                    XCTAssertEqual($0, isCompleted)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isCompleted.toggle()
            viewModel.handleFavoriteBarButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testHandleFavoriteBarButtonWithFailure() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .failure)
        let viewModel = QiitaViewModel(apiClient: apiClient)
        viewModel.searchedQuery.accept("test")
        var isCompleted: Bool = false
        scheduler.scheduleAt(100) {
            viewModel.presentViewController
                .drive(onNext: {
                    XCTAssertNotNil($0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            isCompleted.toggle()
            viewModel.handleFavoriteBarButton()
                .subscribe()
                .disposed(by: disposeBag)
        }
        scheduler.start()
    }

    func testShowGithubWebView() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let apiClient = MockAPIClient(result: .success)
        apiClient.qiitaItems = [
            QiitaItem(id: "testId",
                      title: "testTitle",
                      likesCount: 100,
                      url: "https://google.com",
                      user: QiitaUser(id: "testId2",
                                      profileImageUrl: "https://google.com"))]
        let viewModel = QiitaViewModel(apiClient: apiClient)
        viewModel.searchQuery.accept("test")
        scheduler.scheduleAt(100) {
            viewModel.handleSearchButton()
                .subscribe()
                .disposed(by: disposeBag)
            viewModel.presentViewController
                .drive(onNext: {
                    XCTAssertNotNil($0)
                })
                .disposed(by: disposeBag)
        }
        scheduler.scheduleAt(200) {
            viewModel.showQiitaWebView(
                indexPath: IndexPath(row: 0, section: 0))
        }
        scheduler.start()
    }
}
