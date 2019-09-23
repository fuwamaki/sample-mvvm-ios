//
//  ItemTableCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

private struct Text {
    static let yen = "円"
}

final class ItemTableCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func render(item: Item) {
        titleLabel.text = item.name
        subtitleLabel.text = item.category
        priceLabel.text = String(item.price) + Text.yen
    }
}
