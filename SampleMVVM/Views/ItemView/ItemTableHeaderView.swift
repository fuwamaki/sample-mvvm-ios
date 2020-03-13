//
//  ItemTableHeaderView.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2020/01/29.
//  Copyright © 2020 yusaku maki. All rights reserved.
//

import UIKit

final class ItemTableHeaderView: UITableViewCell {

    @IBOutlet private weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.text = R.string.localizable.items_subtitle()
        }
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
