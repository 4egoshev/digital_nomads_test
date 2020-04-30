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
        setupTableView()
        bind()
    }
    
    private func bind() {
        tableView.reactive.reloadData <~ viewModel.reloadTableView
    }
}

//MARK: - Setup
private extension NewsController {
    func setupTableView() {
        tableView.registerNib(for: NewsCell.self)
    }
}

//MARK: - UITableViewDataSource
extension NewsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cellClass: NewsCell.self, for: indexPath)
        cell.model = viewModel.cellModel(at: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension NewsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}
