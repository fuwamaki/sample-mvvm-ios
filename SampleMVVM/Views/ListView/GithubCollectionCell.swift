//
//  GithubCollectionCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

final class GithubCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            repositorySubject
                .subscribe(onNext: { [unowned self] repository in
                    self.titleLabel.text = repository.fullName
                })
                .disposed(by: disposeBag)
        }
    }

    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            repositorySubject
            .subscribe(onNext: { [unowned self] repository in
                self.iconImageView?.pin_setImage(from: URL(string: repository.owner.avatarUrl))
            })
            .disposed(by: disposeBag)
        }
    }

    @IBOutlet weak var favoriteCountLabel: UILabel! {
        didSet {
            repositorySubject
                .subscribe(onNext: { [unowned self] repository in
                    self.favoriteCountLabel.text = String(repository.stargazersCount)
                })
                .disposed(by: disposeBag)
        }
    }

    private let disposeBag = DisposeBag()
    private let repositorySubject = PublishRelay<GithubRepository>()

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 4.0
    }

    func render(repository: GithubRepository) {
        repositorySubject.accept(repository)
    }
}
