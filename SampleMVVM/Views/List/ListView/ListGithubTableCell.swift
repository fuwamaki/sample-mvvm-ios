//
//  ListGithubTableCell.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/11/15.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ListGithubTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(R.nib.githubCollectionCell)

            collectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            repositories
                .drive(collectionView.rx.items) { collectionView, index, element in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.githubCollectionCell,
                                                                  for: IndexPath(row: index, section: 0))!
                    cell.render(repository: element)
                    return cell }
                .disposed(by: disposeBag)
        }
    }

    private let repositoriesSubject = BehaviorRelay<[GithubRepository]>(value: [])
    var repositories: Driver<[GithubRepository]> {
        return repositoriesSubject.asDriver(onErrorJustReturn: [])
    }

    private let disposeBag = DisposeBag()

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    class func defaultHeight(_ tableView: UITableView) -> CGFloat {
        return 120.0
    }

    func render(repositories: [GithubRepository]) {
        repositoriesSubject.accept(repositories)
    }
}

extension ListGithubTableCell: UICollectionViewDelegate {
}
