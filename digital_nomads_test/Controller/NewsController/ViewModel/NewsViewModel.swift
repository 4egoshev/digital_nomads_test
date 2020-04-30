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
    
    private let prefetchCount = 5
    private var pageSize = 0
    
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
    
    func willDisplayCell(at indexPath: IndexPath) {
        guard indexPath.row >= news.count - prefetchCount else { return }
        request(page: news.count / pageSize + 1)
    }
}

//MARK: - Request
private extension NewsViewModel {
    func request(page: Int = 1) {
        let request: NewsRouter = .getNews(theame: "news", page: page)
        networker.sendRequest(request, success: { [weak self] (response: Articles<News>) in
            guard let self = self else { return }
            self.news.append(contentsOf: response.items)
            if self.pageSize == 0 { self.pageSize = self.news.count }
            self.reloadTableViewObserver.send(value: ())
        })
    }
}
