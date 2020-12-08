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
import SafariServices
import PKHUD

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
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.qiitaTableCell,
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
    private let viewModel: QiitaViewModelable = QiitaViewModel()

    static func make() -> QiitaViewController {
        return R.storyboard.qiitaViewController.instantiateInitialViewController()!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    private func setupViews() {
        view.addSubview(indicator)
        tableView.tableFooterView = UIView()
    }

    // swiftlint:disable function_body_length
    private func bind() {
        viewModel.isLoading
            .subscribe(onNext: { [unowned self] in
                self.isLoading = $0
            })
            .disposed(by: disposeBag)

        viewModel.presentScreen
            .drive(onNext: { [unowned self] screen in
                switch screen {
                case .safari(let url):
                    let safari = SFSafariViewController(url: url)
                    self.present(safari, animated: true, completion: nil)
                case .errorAlert(let message):
                    let alert = UIAlertController.singleErrorAlert(message: message)
                    self.present(alert, animated: true, completion: nil)
                default: break
                }
            })
            .disposed(by: disposeBag)

        viewModel.completedSubject
            .filter { $0 }
            .subscribe(onNext: { _ in
                HUD.flash(.success, delay: 1.0)
            })
            .disposed(by: disposeBag)

        viewModel.searchQueryValid
            .bind(to: searchButton.rx.isEnabled)
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.searchBar.searchTextField.resignFirstResponder()
                self.viewModel.handleSearchButton()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

        viewModel.searchedQueryValid
            .bind(to: favoriteBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isQueryFavorited
            .subscribe(onNext: { [unowned self] in
                self.favoriteBarButtonItem.image = $0
                    ? UIImage(systemName: "checkmark.circle.fill")
                    : UIImage(systemName: "heart.fill")
            })
            .disposed(by: disposeBag)

        favoriteBarButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.handleFavoriteBarButton()
                    .subscribe()
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
    }
}

// MARK: UITableViewDelegate
extension QiitaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QiitaTableCell.defaultHeight(tableView)
    }
}

// MARK: UITextFieldDelegate
extension QiitaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.handleSearchButton()
            .subscribe()
            .disposed(by: disposeBag)
        return true
    }
}
