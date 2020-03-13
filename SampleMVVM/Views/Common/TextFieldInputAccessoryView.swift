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
    private var previousTextField: UITextField?
    private var nextTextField: UITextField?

    init(textField: UITextField, doneButtonTitle: String = R.string.localizable.toolbar_done()) {
        self.textField = textField
        self.doneButtonTitle = doneButtonTitle
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
        setupToolbar()
    }

    init(textField: UITextField, previous: UITextField?, next: UITextField?, doneButtonTitle: String = R.string.localizable.toolbar_done()) {
        self.textField = textField
        self.doneButtonTitle = doneButtonTitle
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
        setupToolbar(previous: previous, next: next)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Please initialize this class programatically")
    }

    private func setupToolbar() {
        // memo: サイズを指定しないと、動作はするが警告が出る
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        toolBar.alpha = 0.7
        toolBar.isTranslucent = true
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(
            title: doneButtonTitle,
            style: .done,
            target: self,
            action: #selector(TextFieldInputAccessoryView.clickDoneButton(_:)))
        let barButtonItems = [flexibleSpace, doneBarButtonItem]
        toolBar.items = barButtonItems
        addSubview(toolBar)
        toolBar.sizeToFit()
    }

    private func setupToolbar(previous: UITextField?, next: UITextField?) {
        // memo: サイズを指定しないと、動作はするが警告が出る
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        toolBar.alpha = 0.7
        toolBar.isTranslucent = true
        previousTextField = previous
        nextTextField = next
        let previousIcon = previous != nil ? R.image.upward()! : R.image.upward_disable()!
        let resizePreviousIcon = previousIcon.resize(width: 30.0, height: 30.0)
        let previousBarButtonItem = UIBarButtonItem(image: resizePreviousIcon, style: .plain, target: self, action: #selector(clickPreviousButton(_:)))
        previousBarButtonItem.isEnabled = previous != nil
        let nextIcon = next != nil ? R.image.downward()! : R.image.downward_disable()!
        let resizeNextIcon = nextIcon.resize(width: 30.0, height: 30.0)
        let nextBarButtonItem = UIBarButtonItem(image: resizeNextIcon, style: .plain, target: self, action: #selector(clickNextButton(_:)))
        nextBarButtonItem.isEnabled = next != nil
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(title: doneButtonTitle,
                                                style: .done,
                                                target: self,
                                                action: #selector(TextFieldInputAccessoryView.clickDoneButton(_:)))
        let barButtonItems = [previousBarButtonItem, nextBarButtonItem, flexibleSpace, doneBarButtonItem]
        toolBar.items = barButtonItems
        addSubview(toolBar)
        toolBar.sizeToFit()
    }
}

// MARK: handle button
extension TextFieldInputAccessoryView {
    @objc private func clickDoneButton(_ sender: AnyObject) {
        if let delegate = delegate, let doneButtonHandler = delegate.handleDoneButton {
            doneButtonHandler(self)
        } else {
            textField?.resignFirstResponder()
        }
    }

    @objc private func clickPreviousButton(_ sender: AnyObject) {
        previousTextField?.becomeFirstResponder()
    }

    @objc private func clickNextButton(_ sender: AnyObject) {
        nextTextField?.becomeFirstResponder()
    }
}
