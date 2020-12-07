//
//  Screen.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/12/07.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Foundation

enum Screen {
    case itemRegister
    case itemUpdate(item: Item)
    case errorAlert(message: String)
    case other
}
