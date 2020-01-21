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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoginManager.shared.setup(channelID: Constants.lineChannelID, universalLinkURL: nil)
        SampleUserNotificationCenter.shared.setupPushNotification()
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if LoginManager.shared.application(application, open: userActivity.webpageURL) {
            return true
        } else {
            return false
        }
    }

    /// SceneDelegateの設定・指定: Info.plist > Application Scene Manifest を参照する
    /// 処理として呼び出されるfunctionではない
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /// タスクキルした瞬間の処理
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // iOS12以前でLINEログインのUniversalLink設定に必要なもの
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        return LoginManager.shared.application(app, open: url)
//    }
}
