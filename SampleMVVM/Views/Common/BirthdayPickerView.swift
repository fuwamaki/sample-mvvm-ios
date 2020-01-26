//
//  BirthdayPickerView.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/25.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BirthdayPickerView: UIView {

    public var selectedDate = BehaviorRelay<Date?>(value: nil)

    private lazy var birthdayPicker: UIDatePicker = {
        let birthdayPicker = UIDatePicker()
        birthdayPicker.datePickerMode = .date
        birthdayPicker.locale = Locale.current
        birthdayPicker.minimumDate = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone.current,
            year: 1900, month: 1, day: 1).date
        birthdayPicker.maximumDate = Date()
        birthdayPicker.setDate(DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone.current, year: 1990, month: 1, day: 1).date ?? Date(), animated: false)
        birthdayPicker.addTarget(self, action: #selector(birthdayPickerValueDidChange(_:)), for: .valueChanged)
        return birthdayPicker
    }()

    override init(frame: CGRect) {
        let view = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        super.init(frame: view)
        setupBirthdayPicker()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBirthdayPicker()
    }

    override func updateConstraints() {
        fitConstraintsContentView()
        super.updateConstraints()
    }

    private func setupBirthdayPicker() {
        addSubview(birthdayPicker)
    }
}

extension BirthdayPickerView {
    public func selectRow(date: Date) {
        birthdayPicker.setDate(date, animated: true)
    }
}

// MARK: handling picker action
extension BirthdayPickerView {
    @objc func birthdayPickerValueDidChange(_ datePicker: UIDatePicker) {
        selectedDate.accept(datePicker.date)
    }
}
