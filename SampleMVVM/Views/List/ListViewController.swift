//
//  ListViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ListViewController: UITableViewController {

    @IBOutlet private weak var githubCollectionView: UICollectionView! {
        didSet {
            githubCollectionView.register(R.nib.collectionListCell)

            githubCollectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            items
                .drive(githubCollectionView.rx.items) { collectionView, index, element in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.collectionListCell,
                                                                  for: IndexPath(row: index, section: 0))!
                    cell.render(element)
                    return cell }
                .disposed(by: disposeBag)
        }
    }

    @IBOutlet private weak var qiitaCollectionView: UICollectionView!

    private let itemsSubject = BehaviorRelay<[String]>(value: ["a", "b", "c", "d", "e", "f", "g", "h"])
    var items: Driver<[String]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    private let disposeBag = DisposeBag()
    private let viewModel: ListViewModelable = ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func setupTableView() {
    }

    private func bind() {
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
