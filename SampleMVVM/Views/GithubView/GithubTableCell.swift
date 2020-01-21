//
//  GithubTableCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit

final class GithubTableCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stargazersCountLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    class func defaultHeight(_ tableView: UITableView) -> CGFloat {
        return 56.0
    }

    func render(repository: GithubRepository) {
        titleLabel.text = repository.fullName
        stargazersCountLabel.text = String(repository.stargazersCount)
        let avatarUrl = repository.owner.avatarUrl
        iconImageView?.pin_setImage(from: URL(string: avatarUrl))
    }
}
