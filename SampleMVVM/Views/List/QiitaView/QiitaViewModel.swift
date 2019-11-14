//
//  QiitaViewModel.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import RxSwift
import RxCocoa
import SafariServices

protocol QiitaViewModelable {
    var isLoading: BehaviorRelay<Bool> { get }
    var qiitaItems: Driver<[QiitaItem]> { get }
    var pushViewController: Driver<UIViewController> { get }
    var errorAlertMessage: Driver<String> { get }
    func fetchQiitaItems(tag: String?) -> Completable
    func showQiitaWebView(indexPath: IndexPath)
}

final class QiitaViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)

    private let qiitaItemsSubject = BehaviorRelay<[QiitaItem]>(value: [])
    var qiitaItems: Driver<[QiitaItem]> {
        return qiitaItemsSubject.asDriver(onErrorJustReturn: [])
    }

    private var pushViewControllerSubject = PublishRelay<UIViewController>()
    var pushViewController: Driver<UIViewController> {
        return pushViewControllerSubject.asDriver(onErrorJustReturn: UIViewController())
    }

    private var errorAlertMessageSubject = PublishRelay<String>()
    var errorAlertMessage: Driver<String> {
        return errorAlertMessageSubject.asDriver(onErrorJustReturn: "")
    }

    private let disposeBag = DisposeBag()
    private let apiClient: APIClientable

    convenience init() {
        self.init(apiClient: APIClient())
    }

    init(apiClient: APIClientable) {
        self.apiClient = apiClient
        subscribe()
    }

    private func subscribe() {
    }
}

extension QiitaViewModel: QiitaViewModelable {
    func fetchQiitaItems(tag: String?) -> Completable {
        guard let tag = tag else {
            return Completable.empty()
        }
        isLoading.accept(true)
        return apiClient.fetchQiitaItems(tag: tag)
            .do(
                onSuccess: { [weak self] items in
                    self?.isLoading.accept(false)
                    self?.qiitaItemsSubject.accept(items)
                },
                onError: { [weak self] error in
                    guard let error = error as? APIError else { return }
                    self?.isLoading.accept(false)
                    self?.errorAlertMessageSubject.accept(error.message)})
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    func showQiitaWebView(indexPath: IndexPath) {
        guard let url = URL(string: qiitaItemsSubject.value[indexPath.row].url) else { return }
        let viewController = SFSafariViewController(url: url)
        viewController.hidesBottomBarWhenPushed = true
        pushViewControllerSubject.accept(viewController)
    }
}
