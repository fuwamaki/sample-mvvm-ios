//
//  QiitaCollectionCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

final class QiitaCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var favoriteCountLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
