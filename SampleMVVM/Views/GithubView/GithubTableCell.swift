//
//  GithubTableCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import PINRemoteImage

final class GithubTableCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stargazersCountLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    class func defaultHeight(_ tableView: UITableView) -> CGFloat {
        return 64.0
    }

    func render(repository: GithubRepository) {
        titleLabel.text = repository.fullName
        stargazersCountLabel.text = String(repository.stargazersCount)
        let avatarUrl = repository.owner.avatarUrl
        iconImageView.image = UIColor.secondarySystemBackground.image
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.transition(
                with: self.iconImageView,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: {
                    self.iconImageView?.pin_setImage(from: URL(string: avatarUrl))
                })
        }
    }
}
