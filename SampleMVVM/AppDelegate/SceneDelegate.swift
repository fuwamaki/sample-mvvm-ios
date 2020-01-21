//
//  SceneDelegate.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import LineSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /// アプリ起動時の初期Windowの設定
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene as? UIWindowScene) != nil else { return }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        _ = LoginManager.shared.application(.shared, open: URLContexts.first?.url)
    }

    /// アプリ起動時に呼ばれる。バックグランドからの再起動時にも呼ばれる。
    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    /// アプリ起動完了後に呼ばれる。バックグランドからの再起動時にも呼ばれる。
    func sceneDidBecomeActive(_ scene: UIScene) {
        SampleUserNotificationCenter.shared.checkHandleTapPushNotification()
    }

    /// バックグラウンドへのスワイプ開始直後に呼ばれる。
    func sceneWillResignActive(_ scene: UIScene) {
    }

    /// バックグラウンド完了後に呼ばれる。
    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    /// タスクキル完了後に呼ばれる。
    func sceneDidDisconnect(_ scene: UIScene) {
    }
}
