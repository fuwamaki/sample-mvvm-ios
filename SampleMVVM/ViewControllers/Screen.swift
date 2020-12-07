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
    case createUser(lineUser: LineUser)
    case updateUser(user: User)
    case mypageActionSheet
    case imagePicker
    case crop(picker: UIImagePickerController, image: UIImage)
    case safari(url: URL)
    case errorAlert(message: String)
    case errorAlertAndDismiss(message: String)
    case other
}
