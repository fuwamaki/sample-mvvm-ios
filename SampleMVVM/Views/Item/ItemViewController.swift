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

    @IBOutlet private weak var registerBarButtonItem: UIBarButtonItem!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.itemTableCell)

            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            viewModel.items
                .drive(tableView.rx.items) { tableView, index, element in
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTableCell,
                                                             for: IndexPath(item: index, section: 0))!
                    cell.render(item: element)
                    return cell }
                .disposed(by: disposeBag)

            tableView.rx.itemSelected
                .subscribe(onNext: { [unowned self] indexPath in
                    self.tableView.deselectRow(at: indexPath, animated: false)
                })
                .disposed(by: disposeBag)

            tableView.rx.itemDeleted
                .subscribe(onNext: { [unowned self] indexPath in
                    self.viewModel.deleteItem(indexPath: indexPath)
                        .subscribe()
                        .disposed(by: self.disposeBag)
                })
            .disposed(by: disposeBag)
        }
    }

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

    private let disposeBag = DisposeBag()
    private let viewModel: ItemViewModelable = ItemViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.fetchItems().subscribe().disposed(by: disposeBag)
    }

    private func setupViews() {
        view.addSubview(indicator)
        // Hide blank border of tableview
        tableView.tableFooterView = UIView()
    }

    private func bind() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] in
                self?.isLoading = $0
            })
            .disposed(by: disposeBag)

        registerBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                let viewController = R.storyboard.itemRegisterViewController.instantiateInitialViewController()!
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemTableCell.defaultHeight(tableView)
    }
}
