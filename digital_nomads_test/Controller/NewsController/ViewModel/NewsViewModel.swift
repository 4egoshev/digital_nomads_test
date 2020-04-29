//
//  NewsViewModel.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import ReactiveSwift
import Result
import Alamofire

class NewsViewModel: BaseViewModel {
    
    let reloadTableView: Signal<(), NoError>
    private let reloadTableViewObserver: Signal<(), NoError>.Observer
    
    private var news = [News]()
    
    private let networker: Networker<NewsRouter>

    init(networker: Networker<NewsRouter> = Networker<NewsRouter>()) {
        self.networker = networker
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
        let request: NewsRouter = .getNews(theame: "today", page: 1)
        networker.sendRequest(request, success: { [weak self] (response: Articles<News>) in
            self?.news.append(contentsOf: response.items)
            self?.reloadTableViewObserver.send(value: ())
        })
    }
}
