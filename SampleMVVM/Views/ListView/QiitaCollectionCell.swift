//
//  QiitaCollectionCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/24.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

final class QiitaCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            qiitaItemSubject
                .subscribe(onNext: { [unowned self] qiitaItem in
                    self.iconImageView?
                        .pin_setImage(from: URL(string: qiitaItem.user.profileImageUrl))
                })
                .disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            qiitaItemSubject
                .subscribe(onNext: { [unowned self] qiitaItem in
                    self.titleLabel.text = qiitaItem.title
                })
                .disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var favoriteCountLabel: UILabel! {
        didSet {
            qiitaItemSubject
                .subscribe(onNext: { [unowned self] qiitaItem in
                    self.favoriteCountLabel.text = String(qiitaItem.likesCount)
                })
                .disposed(by: disposeBag)
        }
    }

    private let disposeBag = DisposeBag()
    private let qiitaItemSubject = PublishRelay<QiitaItem>()

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 4.0
    }

    func render(qiitaItem: QiitaItem) {
        qiitaItemSubject.accept(qiitaItem)
    }
}
