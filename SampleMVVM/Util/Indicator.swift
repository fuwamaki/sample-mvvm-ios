//
//  Indicator.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/26.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

var defaultIndicator: UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView()
    indicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
    indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    indicator.hidesWhenStopped = true
    indicator.color = UIColor.link
    indicator.isHidden = true
    return indicator
}
