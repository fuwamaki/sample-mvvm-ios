//
//  ItemViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.itemTableCell)

            viewModel.items
                .drive(tableView.rx.items) { tableView, index, element in
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTableCell,
                                                             for: IndexPath(item: index, section: 0))!
                    cell.render(item: element)
                    return cell }
                .disposed(by: disposeBag)

            tableView.rx.itemSelected
                .subscribe(onNext: { [weak self] indexPath in
                    self?.tableView.deselectRow(at: indexPath, animated: false)
                })
                .disposed(by: disposeBag)
        }
    }

    private let disposeBag = DisposeBag()
    private let viewModel: ItemViewModetable = ItemViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
    }
}
