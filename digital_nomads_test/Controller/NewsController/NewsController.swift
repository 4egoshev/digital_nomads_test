//
//  NewsController.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 27.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit
import SwiftUtilites
import ReactiveCocoa
import ReactiveSwift

class NewsController: BaseController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    
    @IBOutlet private var dataProvider: NewsDataProvider!
    
    private var loadIndicator: UIActivityIndicatorView!
    
    private let viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupKeyboardHandler()
        setupLoadIndicator()
        bind()
    }
    
    private func bind() {
        tableView.reactive.reloadData <~ viewModel.reloadTableView
        tableView.refreshControl?.reactive.isRefreshing <~ viewModel.refreshing
        placeholderLabel.reactive.isHidden <~ viewModel.placeholderHidden
        loading <~ viewModel.loading
    }
}

//MARK: - Setup
private extension NewsController {
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func setupTableView() {
        dataProvider.viewModel = viewModel
        
        tableView.tableFooterView = UIView()
        tableView.registerNib(for: NewsCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupKeyboardHandler() {
        keyboardHandler.setup(scrollView: tableView, mainView: navigationItem.searchController?.searchBar)
    }
    
    func setupLoadIndicator() {
        loadIndicator = UIActivityIndicatorView(style: .gray)
        loadIndicator.startAnimating()
        loadIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
    }
}

//MARK: - Reactive
private extension NewsController {
    var loading: BindingTarget<Bool> {
        return BindingTarget(lifetime: lifetime) { [weak self] (isLoading) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.tableFooterView = isLoading ? self.loadIndicator : UIView()
            }
        }
    }
}

//MARK: - Action
private extension NewsController {
    @objc func refreshNews() {
        viewModel.refreshNews()
    }
}

//MARK: - NewsController
extension NewsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.request(theme: text)
    }
}
