//
//  UIWindow+Motion.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/21.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

extension UIWindow {
    open override func becomeFirstResponder() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    open override var canBecomeFirstResponder: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        switch motion {
        case .motionShake:
            #if DEBUG
            if let navigationController = UIApplication.topViewController() as? UINavigationController {
                let debugViewController = navigationController.viewControllers
                    .filter { $0.isKind(of: DebugViewController.self) }
                    .first
                if debugViewController != nil {
                    UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                }
            } else {
                let viewController = DebugViewController.make()
                let navigationController = UINavigationController(rootViewController: viewController)
                UIApplication.topViewController()?.present(navigationController, animated: true, completion: nil)
            }
            #endif
        default:
            break
        }
    }
}
