//
//  SampleUserNotificationCenter.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/21.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit
import UserNotifications

final class SampleUserNotificationCenter: NSObject {

    static var shared = SampleUserNotificationCenter()
    private var userInfoForLaunch: [AnyHashable: Any]?

    func setupPushNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = SampleUserNotificationCenter.shared
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            print(granted)
        }
    }

    func checkHandleTapPushNotification() {
        if let userInfo = userInfoForLaunch {
            handlePushNotificationRoute(userInfo)
            userInfoForLaunch = nil
        }
    }
}

// MARK: UNUserNotificationCenterDelegate
extension SampleUserNotificationCenter: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void) {
        // memo: ForeGroundでも通知を受け取れるようにする
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // 既にUIViewController表示済みなら、Push通知のハンドリングを実施
        if UIApplication.topViewController() != nil {
            handlePushNotificationRoute(userInfo)
        } else {
            // まだUIViewControllerが表示されていない（まだLaunchScreen）場合、sceneDidBecomeActiveでハンドリングをする
            userInfoForLaunch = userInfo
        }
        completionHandler()
    }
}

// MARK: handle user notification action
extension SampleUserNotificationCenter {
    private func handlePushNotificationRoute(_ userInfo: [AnyHashable: Any]) {
        if let type = userInfo["type"] as? String {
            if type == "debug" {
                let viewController = DebugViewController.make()
                let navigationController = UINavigationController(rootViewController: viewController)
                UIApplication.topViewController()?.present(navigationController, animated: true, completion: nil)
            }
        }
    }
}
