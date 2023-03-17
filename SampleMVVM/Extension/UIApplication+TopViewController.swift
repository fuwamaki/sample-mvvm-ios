//
//  UIApplication+TopViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/21.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

extension UIApplication {
    // keyWindow for iOS13 or later
    // https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0
    var rootViewControllerInKeyWindow: UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
    }

    // to know the most front screen
    class func keyWindowTopViewController(
        on controller: UIViewController? = UIApplication.shared.rootViewControllerInKeyWindow
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return keyWindowTopViewController(on: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController,
            let selected = tabController.selectedViewController {
            return keyWindowTopViewController(on: selected)
        }
        if let presented = controller?.presentedViewController {
            return keyWindowTopViewController(on: presented)
        }
        return controller
    }

    // to display screen as the most front screen
    class func topViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.rootViewControllerInKeyWindow else { return nil }
        var presentedViewController = rootViewController.presentedViewController
        if presentedViewController == nil {
            return rootViewController
        } else {
            while presentedViewController?.presentedViewController != nil {
                presentedViewController = presentedViewController?.presentedViewController
            }
            return presentedViewController
        }
    }
}
