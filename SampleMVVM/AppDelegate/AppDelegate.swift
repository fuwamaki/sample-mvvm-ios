//
//  AppDelegate.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import LineSDK
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        LoginManager.shared.setup(
            channelID: Constants.lineChannelID,
            universalLinkURL: URL(string: Url.lineUniversalLinkURL)
        )
        SampleUserNotificationCenter.shared.setupPushNotification()
        return true
    }

    // LINEログイン universal linkのURLとして対象かどうかを設定
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        return LoginManager.shared.application(
            application,
            open: userActivity.webpageURL
        ) || userActivity.activityType == NSUserActivityTypeBrowsingWeb
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}

    // iOS12以前でLINEログインのUniversalLink設定に必要
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return LoginManager.shared.application(app, open: url)
    }
}
