//
//  UIImage+Addition.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/01.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(width: CGFloat, height: CGFloat) -> UIImage? {
        let resizedSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
