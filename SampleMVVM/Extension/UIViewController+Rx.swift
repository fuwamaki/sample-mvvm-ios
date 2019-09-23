//
//  UIViewController+Rx.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

// reference
// https://github.com/tryswift/RxPagination/blob/master/Pagination/UIViewController%2BRx.swift

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }

    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }

    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillDisappear))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidDisappear))
    }

    var viewWillLayoutSubviews: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillLayoutSubviews))
    }

    var viewDidLayoutSubviews: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidLayoutSubviews))
    }

    var willMoveToParent: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.willMove(toParent:)))
    }

    var didMoveToParent: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.didMove(toParent:)))
    }

    var didReceiveMemoryWarning: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.didReceiveMemoryWarning))
    }
}
