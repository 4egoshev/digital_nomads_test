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
    
    let refreshing: Signal<Bool, NoError>
    private let refreshingObserver: Signal<Bool, NoError>.Observer
    
    let loading: Signal<Bool, NoError>
    private let loadingObserver: Signal<Bool, NoError>.Observer
    
    private let prefetchCount = 1
    private var currentPage = 1
    private var pageSize = 0
    private var theame = "news"
    
    private var news = [News]()
    
    private let networker: Networker<NewsRouter>

    init(networker: Networker<NewsRouter> = Networker<NewsRouter>()) {
        self.networker = networker
        
        (reloadTableView, reloadTableViewObserver) = Signal.pipe()
        (refreshing, refreshingObserver) = Signal.pipe()
        (loading, loadingObserver) = Signal.pipe()
        
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
        guard indexPath.row >= news.count - prefetchCount, currentPage == news.count / pageSize else { return }
        currentPage = news.count / pageSize + 1
        request(page: currentPage)
    }
}

//MARK: - Request
extension NewsViewModel {
    func refreshNews() {
        request(theame: theame)
    }
    
    func request(page: Int = 1, theame: String = "news") {
        self.theame = !theame.isEmpty ? theame : "news"
        loadingObserver.send(value: true)
        let request: NewsRouter = .getNews(theame: self.theame, page: page)
        networker.sendRequest(request, success: { [weak self] (response: Articles<News>) in
            guard let self = self else { return }
            page == 1 ? self.news = response.items : self.news.append(contentsOf: response.items)
            if self.pageSize == 0 { self.pageSize = self.news.count }
            self.reloadTableViewObserver.send(value: ())
            self.refreshingObserver.send(value: false)
            self.loadingObserver.send(value: false)
        }) { (error) in
            self.refreshingObserver.send(value: false)
        }
    }
}
