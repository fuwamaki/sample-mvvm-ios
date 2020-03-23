//
//  DebugViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/21.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UserNotifications

final class DebugViewController: UITableViewController {

    private let disposeBag = DisposeBag()

    static func make() -> DebugViewController {
        let viewController = R.storyboard.debugViewController.instantiateInitialViewController()!
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    private func setupViews() {
        // Hide blank border of tableview
        tableView.tableFooterView = UIView()
    }

    private func bind() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
                switch indexPath {
                case IndexPath(row: 0, section: 0):
                    self.handleLocalPushTestButton()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: handle action
extension DebugViewController {
    private func handleLocalPushTestButton() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        let content = UNMutableNotificationContent()
        content.body = "ローカルPushテスト debug"
        let userInfo: [String: Any] = ["type": "debug"]
        content.userInfo = userInfo
        let request = UNNotificationRequest(identifier: "TestLocalnotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
}
