//
//  ListQiitaTableCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/16.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ListQiitaTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(R.nib.qiitaCollectionCell)

            collectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            qiitaItems
                .drive(collectionView.rx.items) { collectionView, index, element in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.qiitaCollectionCell,
                                                                  for: IndexPath(row: index, section: 0))!
                    cell.render(qiitaItem: element)
                    return cell }
                .disposed(by: disposeBag)
        }
    }

    private let qiitaItemsSubject = BehaviorRelay<[QiitaItem]>(value: [])
    var qiitaItems: Driver<[QiitaItem]> {
        return qiitaItemsSubject.asDriver(onErrorJustReturn: [])
    }

    private let disposeBag = DisposeBag()

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    class func defaultHeight(_ tableView: UITableView) -> CGFloat {
        return 120.0
    }

    func render(qiitaItems: [QiitaItem]) {
        qiitaItemsSubject.accept(qiitaItems)
    }
}

extension ListQiitaTableCell: UICollectionViewDelegate {
}

extension ListQiitaTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
}
