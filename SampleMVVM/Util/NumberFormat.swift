//
//  NumberFormat.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/29.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import Foundation

final class PriceFormat {

    static func price(_ priceInt: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        return numberFormatter.string(from: priceInt as NSNumber)
    }

    static func price(_ priceString: String) -> String? {
        guard let priceInt = Int(priceString) else {
            return nil
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        return numberFormatter.string(from: priceInt as NSNumber)
    }
}
