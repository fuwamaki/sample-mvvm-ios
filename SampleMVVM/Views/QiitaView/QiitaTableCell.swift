//
//  QiitaTableCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import PINRemoteImage

final class QiitaTableCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    class func defaultHeight(_ tableView: UITableView) -> CGFloat {
        return 64.0
    }

    func render(item: QiitaItem) {
        titleLabel.text = item.title
        likesCountLabel.text = String(item.likesCount)
        let profileImageUrl = item.user.profileImageUrl
        iconImageView?.pin_setImage(from: URL(string: profileImageUrl))
    }
}
