//
//  UIViewController+Router.swift
//  SampleMVVM
//
//  Created by fuwamaki on 2022/03/22.
//  Copyright © 2022 yusaku maki. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentScreen(_ screen: Screen) {
        switch screen {
        case .safari(let url):
            let safari = SFSafariViewController(url: url)
            present(safari, animated: true, completion: nil)
        case .mypageActionSheet(let logoutAction):
            let actionSheet = UIAlertController(
                title: R.string.localizable.mypage_setting_menu_title(),
                message: nil,
                preferredStyle: .actionSheet
            )
            actionSheet.addAction(
                UIAlertAction(
                    title: R.string.localizable.mypage_setting_menu_logout(),
                    style: .destructive,
                    handler: { _ in
                        logoutAction()
                    })
            )
            actionSheet.addAction(
                UIAlertAction(
                    title: R.string.localizable.mypage_setting_menu_cancel(),
                    style: .cancel,
                    handler: nil)
            )
            present(actionSheet, animated: true, completion: nil)
        case .errorAlert(let message):
            let alert = UIAlertController.singleErrorAlert(message: message)
            present(alert, animated: true, completion: nil)
        default: break
        }
    }
}
