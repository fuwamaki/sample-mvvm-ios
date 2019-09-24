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

final class ListViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(R.nib.collectionListCell)

            items.drive(collectionView.rx.items) { collectionView, index, element in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.collectionListCell, for: IndexPath(row: index, section: 0))!
                cell.render(element)
                return cell
            }.disposed(by: disposeBag)
        }
    }

    private let itemsSubject = BehaviorRelay<[String]>(value: ["a", "b"])
    var items: Driver<[String]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    private let disposeBag = DisposeBag()
    private let viewModel: ListViewModelable = ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
    }
}
