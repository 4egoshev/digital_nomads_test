//
//  NewsViewModel.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import ReactiveSwift
import Result

class NewsViewModel: BaseViewModel {
    
    let reloadTableView: Signal<(), NoError>
    private let reloadTableViewObserver: Signal<(), NoError>.Observer
    
    private var news = [News]()

    override init() {
        (reloadTableView, reloadTableViewObserver) = Signal.pipe()
        super.init()
        request()
    }
}

//MARK: - TableView
extension NewsViewModel {
    func numberOfRows(in section: Int) -> Int {
        return news.count
    }
    
    func cellModel(at indexPath: IndexPath) -> NewsCell.Model? {
        let currentNews = news[indexPath.row]
        return NewsCell.Model(title: currentNews.title, description: currentNews.description, imageUrl: currentNews.imageUrl)
    }
}

//MARK: - Request
private extension NewsViewModel {
    func request() {
        let request: Router = .getNews(theame: "apple", date: Date(), page: 1)
        Networker.shared.sendRequest(request, success: { [weak self] (response: Articles<News>) in
            self?.news.append(contentsOf: response.items)
            self?.reloadTableViewObserver.send(value: ())
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
}
