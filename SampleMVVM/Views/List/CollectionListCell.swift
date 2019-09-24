//
//  CollectionListCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

final class CollectionListCell: UICollectionViewCell {

    @IBOutlet private weak var sampleLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func render(_ text: String) {
        sampleLabel.text = text
    }
}
