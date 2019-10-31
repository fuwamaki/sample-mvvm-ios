//
//  TextFieldInputAccessoryView.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/31.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

@objc protocol TextFieldInputAccessoryViewDelegate: class {
    @objc optional func handleDoneButton(_ inputAccessoryView: TextFieldInputAccessoryView)
}

final class TextFieldInputAccessoryView: UIView {

    weak var delegate: TextFieldInputAccessoryViewDelegate?
    weak var textField: UITextField?

    private let doneButtonTitle: String
    private let toolBar = UIToolbar()

    init(textField: UITextField, doneButtonTitle: String = "完了") {
        self.textField = textField
        self.doneButtonTitle = doneButtonTitle
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
        setupToolbar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Please initialize this class programatically")
    }

    private func setupToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        toolBar.alpha = 0.7
        toolBar.isTranslucent = true
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(title: doneButtonTitle,
                                                style: .done,
                                                target: self,
                                                action: #selector(TextFieldInputAccessoryView.clickDoneButton(_:)))
        let barButtonItems = [flexibleSpace, doneBarButtonItem]
        toolBar.items = barButtonItems
        addSubview(toolBar)
        toolBar.sizeToFit()
    }

    @objc func clickDoneButton(_ sender: AnyObject) {
        if let delegate = delegate, let doneButtonHandler = delegate.handleDoneButton {
            doneButtonHandler(self)
        } else {
            textField?.resignFirstResponder()
        }
    }
}
