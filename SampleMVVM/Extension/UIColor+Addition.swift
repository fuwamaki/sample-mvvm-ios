//
//  UIColor+Addition.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/29.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

extension UIColor {
    // UIColorをUIImage化するextension
    public var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
