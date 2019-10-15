//
//  GithubViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class GithubViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
        }
    }

    @IBOutlet private weak var searchButton: UIButton!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.githubTableCell)

            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            viewModel.repositories
                .drive(tableView.rx.items) { tableView, index, element in
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.githubTableCell,
                                                             for: IndexPath(item: index, section: 0))!
                    cell.render(repository: element)
                    return cell }
                .disposed(by: disposeBag)

            tableView.rx.itemSelected
                .subscribe(onNext: { [unowned self] indexPath in
                    self.tableView.deselectRow(at: indexPath, animated: false)
                    self.viewModel.showGithubWebView(indexPath: indexPath)})
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
    private let viewModel: GithubViewModelable = GithubViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white
    }

    private func bind() {
        viewModel.isLoading
            .subscribe(onNext: { [unowned self] in
                self.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.pushViewController
            .drive(onNext: { [unowned self] viewController in
                self.navigationController?
                    .pushViewController(viewController, animated: true)})
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.fetchRepositories(query: self.searchBar.text)
                    .subscribe()
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}

extension GithubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GithubTableCell.defaultHeight(tableView)
    }
}