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
//            tableView.register(R.nib.)
//            tableView.registerForCell(GithubTableCell.self)
//            tableView.delegate = self
//            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.backgroundColor = UIColor.white
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

    private var isHideIndicator: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.isHideIndicator ? self.indicator.stopAnimating() : self.indicator.startAnimating()
                self.indicator.isHidden = self.isHideIndicator
            }
        }
    }

    private let disposeBag = DisposeBag()
    private let viewModel: GithubViewModelable = GithubViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func setupTableView() {
    }

    private func bind() {
    }
}

extension GithubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GithubTableCell.defaultHeight(tableView)
    }
}
