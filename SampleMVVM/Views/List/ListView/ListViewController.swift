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

    @IBOutlet private weak var githubBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var qiitaBarButtonItem: UIBarButtonItem!

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

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.black
        indicator.isHidden = true
        return indicator
    }()

    private var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.isLoading ? self.indicator.startAnimating() : self.indicator.stopAnimating()
                self.indicator.isHidden = !self.isLoading
            }
        }
    }

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

    private func bind() {
        rx.viewWillAppear
        .bind(to: viewModel.viewWillAppear)
        .disposed(by: disposeBag)

        viewModel.isLoading
            .subscribe(onNext: { [weak self] in
                self?.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.pushViewController
        .drive(onNext: { [unowned self] viewController in
            self.navigationController?.pushViewController(viewController, animated: true)})
        .disposed(by: disposeBag)

        githubBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.showGithubView()})
            .disposed(by: disposeBag)

        qiitaBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.showGithubView()})
            .disposed(by: disposeBag)
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
