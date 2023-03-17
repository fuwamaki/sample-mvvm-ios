//
//  UINavigationController+Router.swift
//  SampleMVVM
//
//  Created by fuwamaki on 2022/03/22.
//  Copyright © 2022 yusaku maki. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushScreen(_ screen: Screen) {
        switch screen {
        case .itemRegister:
            let viewController = ItemRegisterViewController.make()
            pushViewController(viewController, animated: true)
        case .itemUpdate(let item):
            let viewController = ItemRegisterViewController.make(item: item)
            pushViewController(viewController, animated: true)
        case .github:
            let viewController = GithubViewController.make()
            pushViewController(viewController, animated: true)
        case .qiita:
            let viewController = QiitaViewController.make()
            pushViewController(viewController, animated: true)
        case .createAppleUser(let user):
            let viewController = UserRegistrationViewController.make(type: .createAppleUser(user))
            pushViewController(viewController, animated: true)
        case .createLineUser(let user):
            let viewController = UserRegistrationViewController.make(type: .createLineUser(user))
            pushViewController(viewController, animated: true)
        case .updateUser(let user):
            let viewController = UserRegistrationViewController.make(type: .update(user: user))
            pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
