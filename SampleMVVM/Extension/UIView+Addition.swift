//
//  UIView+Addition.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/25.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

extension UIView {
    // contentViewを自身の大きさに合わせた制約を追加する
    func fitConstraintsContentView(view: UIView? = nil, top: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        if let contentView = view == nil ? subviews.first : view {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: top),
                contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left),
                contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: right),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom)
            ])
        }
    }
}

// MARK: @IBInspectable storyboard上で設定できるように
extension UIView {
    @IBInspectable var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidthView: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColorView: UIColor? {
        get {
            return UIColor.init(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
