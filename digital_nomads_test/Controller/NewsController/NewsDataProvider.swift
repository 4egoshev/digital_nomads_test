//
//  NewsDataProvider.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit

class NewsDataProvider: NSObject {
    var viewModel: NewsViewModel!
    
    override init() {
        super.init()
    }
}

//MARK: - UITableViewDataSource
extension NewsDataProvider: UITableViewDataSource {
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
extension NewsDataProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}
