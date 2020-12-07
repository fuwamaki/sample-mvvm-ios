//
//  Screen.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/12/07.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

enum Screen {
    case itemRegister
    case itemUpdate(item: Item)
    case github
    case qiita
    case createAppleUser(_ user: AppleUser)
    case createLineUser(_ user: LineUser)
    case updateUser(user: User)
    case mypageActionSheet
    case imagePicker
    case crop(picker: UIImagePickerController, image: UIImage)
    case safari(url: URL)
    case errorAlert(message: String)
    case errorAlertAndDismiss(message: String)
    case other
}

// for unit test
// swiftlint:disable operator_whitespace
func ==(a: Screen, b: Screen) -> Bool {
    switch (a, b) {
    case (.itemRegister, .itemRegister),
         (.itemUpdate, .itemUpdate),
         (.github, .github),
         (.qiita, .qiita),
         (.createAppleUser, .createAppleUser),
         (.createLineUser, .createLineUser),
         (.updateUser, .updateUser),
         (.mypageActionSheet, .mypageActionSheet),
         (.imagePicker, .imagePicker),
         (.crop, .crop),
         (.safari, .safari),
         (.errorAlert, .errorAlert),
         (.errorAlertAndDismiss, .errorAlertAndDismiss),
         (.other, .other):
        return true
    default:
        return false
    }
}
