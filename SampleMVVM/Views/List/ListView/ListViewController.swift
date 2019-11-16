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

    @IBOutlet private weak var githubBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var qiitaBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.listGithubTableCell)
            tableView.register(R.nib.listQiitaTableCell)

            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            tableView.rx
                .setDataSource(self)
                .disposed(by: disposeBag)

            viewModel.contentsSubject.subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }})
                .disposed(by: disposeBag)
        }
    }

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
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
        setupViews()
        bind()
    }

    private func setupViews() {
        view.addSubview(indicator)
        // Hide blank border of tableview
        tableView.tableFooterView = UIView()
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
                self.viewModel.showQiitaView()})
            .disposed(by: disposeBag)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ListGithubTableCell.defaultHeight(tableView)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.contentsSubject.value[section].type.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.contentsSubject.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = viewModel.contentsSubject.value[indexPath.section]
        switch element.type {
        case .github:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listGithubTableCell, for: indexPath)!
            cell.render(repositories: element.contents as! [GithubRepository])
            return cell
        case .qiita:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listQiitaTableCell, for: indexPath)!
            cell.render(qiitaItems: element.contents as! [QiitaItem])
            return cell
        case .other:
            return UITableViewCell()
        }
    }
}
