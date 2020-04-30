//
//  NewsDataProvider.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit

class NewsDataProvider: NSObject {
    var viewModel: NewsViewModel?
}

//MARK: - UITableViewDataSource
extension NewsDataProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { fatalError("Set provider viewModel") }
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { fatalError("Set provider viewModel") }
        let cell = tableView.dequeueCell(cellClass: NewsCell.self, for: indexPath)
        cell.model = viewModel.cellModel(at: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension NewsDataProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { fatalError("Set provider viewModel") }
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { fatalError("Set provider viewModel") }
        viewModel.willDisplayCell(at: indexPath)
    }
}
