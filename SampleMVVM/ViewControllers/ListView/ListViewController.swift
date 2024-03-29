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

protocol ListTableDelegate: AnyObject {
    func showWebView(_ viewController: UIViewController)
}

final class ListViewController: UIViewController {

    @IBOutlet private weak var githubBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var qiitaBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.listGithubTableCell)
            tableView.register(R.nib.listQiitaTableCell)
            tableView.tableFooterView = UIView()

            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            tableView.rx
                .setDataSource(self)
                .disposed(by: disposeBag)

            viewModel.contentsSubject
                .subscribe(onNext: { [weak self] contents in
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.noContentLabel.isHidden = contents.count != 0
                    }})
                .disposed(by: disposeBag)
        }
    }

    @IBOutlet private weak var noContentLabel: UILabel!

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = defaultIndicator
        indicator.center = view.center
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
    private let viewModel: ListViewModelable = ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicator)
        setupTexts()
        bind()
    }

    private func setupTexts() {
        navigationItem.title = R.string.localizable.list_title()
        noContentLabel.text = R.string.localizable.list_no_content()
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

        viewModel.presentScreen
            .drive(onNext: { [unowned self] in
                self.presentScreen($0)
            })
            .disposed(by: disposeBag)

        viewModel.pushScreen
            .drive(onNext: { [unowned self] in
                self.navigationController?.pushScreen($0)
            })
            .disposed(by: disposeBag)

        githubBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.showGithubView()})
            .disposed(by: disposeBag)

        qiitaBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.showQiitaView()})
            .disposed(by: disposeBag)
    }
}

// MARK: ListTableDelegate
extension ListViewController: ListTableDelegate {
    func showWebView(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return ListGithubTableCell.defaultHeight(tableView)
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.systemGroupedBackground
        label.textColor = UIColor.label
        label.text = viewModel.contentsSubject.value[section].sectionTitle
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        return label
    }
}

// MARK: UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.contentsSubject.value.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let element = viewModel.contentsSubject.value[indexPath.section]
        switch element.type {
        case .github:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: R.reuseIdentifier.listGithubTableCell,
                for: indexPath
            )!
            cell.render(repositories: element.contents as! [GithubRepository])
            cell.delegate = self
            return cell
        case .qiita:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: R.reuseIdentifier.listQiitaTableCell,
                for: indexPath
            )!
            cell.render(qiitaItems: element.contents as! [QiitaItem])
            cell.delegate = self
            return cell
        case .other:
            return UITableViewCell()
        }
    }
}
