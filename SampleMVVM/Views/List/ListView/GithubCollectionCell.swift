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

    private let disposeBag = DisposeBag()
    private let repositorySubject = PublishRelay<GithubRepository>()

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func render(repository: GithubRepository) {
        repositorySubject.accept(repository)
    }
}
