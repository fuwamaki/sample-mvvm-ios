//
//  ItemTableCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

final class ItemTableCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    class func defaultHeight(_ tableView: UITableView) -> CGFloat {
        return 56.0
    }

    func render(item: Item) {
        titleLabel.text = item.name
        subtitleLabel.text = R.string.localizable.items_subtitle_category() + ": " + item.category
        if let price = PriceFormat.price(item.price) {
            priceLabel.text = price + " " + R.string.localizable.items_price_yen()
        }
    }
}
