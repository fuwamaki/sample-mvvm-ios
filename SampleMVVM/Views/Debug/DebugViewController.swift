//
//  DebugViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/21.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

final class DebugViewController: UIViewController {

    static func make() -> DebugViewController {
        let viewController = R.storyboard.debugViewController.instantiateInitialViewController()!
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
