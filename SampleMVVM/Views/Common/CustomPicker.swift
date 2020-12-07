//
//  CustomPicker.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/31.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomPicker: NSObject {
    var array: [String] = []
    var selectedContent = BehaviorRelay<String?>(value: nil)
}

// MARK: UIPickerViewDataSource
extension CustomPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
}

// MARK: UIPickerViewDelegate
extension CustomPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedContent.accept(array[row])
    }
}
