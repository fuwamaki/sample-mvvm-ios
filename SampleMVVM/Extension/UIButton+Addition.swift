//
//  UIButton+Addition.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/29.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

// MARK: @IBInspectable storyboard上で設定できるように
extension UIButton {
    @IBInspectable var disableBackgroundColor: UIColor? {
        get {
            return backgroundColor
        }
        set {
            setBackgroundImage(newValue?.image, for: .disabled)
        }
    }

    @IBInspectable var disableTintColor: UIColor? {
        get {
            return tintColor
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }
}
