//
//  QiitaViewController.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/10/14.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class QiitaViewController: UIViewController {

    @IBOutlet private weak var favoriteBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
            searchBar.searchTextField.delegate = self
            let view = TextFieldInputAccessoryView(textField: searchBar.searchTextField)
            searchBar.inputAccessoryView = view
        }
    }
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.qiitaTableCell)

            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            viewModel.qiitaItems
                .drive(tableView.rx.items) { tableView, index, element in
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.qiitaTableCell,
                                                             for: IndexPath(item: index, section: 0))!
                    cell.render(item: element)
                    return cell }
                .disposed(by: disposeBag)

            tableView.rx.itemSelected
                .subscribe(onNext: { [unowned self] indexPath in
                    self.tableView.deselectRow(at: indexPath, animated: false)
                    self.viewModel.showQiitaWebView(indexPath: indexPath)})
                .disposed(by: disposeBag)
        }
       }

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.link
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
    private let viewModel: QiitaViewModelable = QiitaViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    private func setupViews() {
        view.addSubview(indicator)
        tableView.tableFooterView = UIView()
    }

    private func bind() {
        viewModel.isLoading
            .subscribe(onNext: { [unowned self] in
                self.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.errorAlertMessage
            .drive(onNext: { [unowned self] message in
                let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.pushViewController
            .drive(onNext: { [unowned self] viewController in
                self.navigationController?
                    .pushViewController(viewController, animated: true)})
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.searchBar.searchTextField.resignFirstResponder()
                self.viewModel.fetchQiitaItems(tag: self.searchBar.text)
                    .subscribe()
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

        favoriteBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.saveKeyword(query: self.searchBar.text)
            })
            .disposed(by: disposeBag)
    }
}

extension QiitaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QiitaTableCell.defaultHeight(tableView)
    }
}

extension QiitaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.fetchQiitaItems(tag: searchBar.text)
            .subscribe()
            .disposed(by: disposeBag)
        return true
    }
}
