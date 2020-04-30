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
    
    let placeholderHidden: Signal<Bool, NoError>
    private let placeholderHiddenObserver: Signal<Bool, NoError>.Observer
    
    let loading: Signal<Bool, NoError>
    private let loadingObserver: Signal<Bool, NoError>.Observer
    
    let pushViewController: Signal<UIViewController, NoError>
    private let pushViewControllerObserver: Signal<UIViewController, NoError>.Observer
    
    private let prefetchCount = 5
    private var currentPage = 1
    private var pageSize = 0
    private var theme = "news"
    
    private var news = [News]() {
        willSet {
            dataBase.update(news: newValue)
        }
    }
    
    private let networker: Networker<NewsRouter>
    private let dataBase: NewsDataBase

    init(news: [News],
         networker: Networker<NewsRouter> = Networker<NewsRouter>(),
         dataBase: NewsDataBase = NewsDataBase()) {
        self.news = news
        self.networker = networker
        self.dataBase = dataBase
        
        (reloadTableView, reloadTableViewObserver) = Signal.pipe()
        (refreshing, refreshingObserver) = Signal.pipe()
        (placeholderHidden, placeholderHiddenObserver) = Signal.pipe()
        (loading, loadingObserver) = Signal.pipe()
        (pushViewController, pushViewControllerObserver) = Signal.pipe()
        
        super.init()
        setupPageSize()
        request()
        bind()
    }
    
    private func setupPageSize() {
        pageSize = !news.isEmpty ? news.count : 20
    }
    
    private func bind() {
        update <~ app.updateCenter.update
    }
}

//MARK: - Reactive
private extension NewsViewModel {
    var update: BindingTarget<UpdateEvent> {
        return BindingTarget(lifetime: lifetime) { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .online(let online):
                guard online else { return }
                self.request(page: self.currentPage, theme: self.theme)
            }
        }
    }
}

//MARK: - TableView
extension NewsViewModel {
    func numberOfRows(in section: Int) -> Int {
        return news.count
    }
    
    func cellModel(at indexPath: IndexPath) -> NewsCell.Model? {
        let currentNews = news[indexPath.row]
        return NewsCell.Model(title: currentNews.title, description: currentNews.descript, imageUrlString: currentNews.imageUrlString)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let urlString = news[indexPath.row].urlString, let url = URL(string: urlString) else { return }
        let viewModel = NewsDetailViewModel(url: url)
        let controller = NewsDetailController(viewModel: viewModel)
        pushViewControllerObserver.send(value: controller)
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
        request(theme: theme)
    }
    
    func request(page: Int = 1, theme: String = "news") {
        self.theme = !theme.isEmpty ? theme : "news"
        loadingObserver.send(value: true)
        self.placeholderHiddenObserver.send(value: true)
        let request: NewsRouter = .getNews(theame: self.theme, page: page)
        networker.sendRequest(request, success: { [weak self] (response: Articles<News>) in
            guard let self = self else { return }
            page == 1 ? self.news = response.items : self.news.append(contentsOf: response.items)
            if self.pageSize == 0 { self.pageSize = self.news.count }
            self.reloadTableViewObserver.send(value: ())
            self.refreshingObserver.send(value: false)
            self.loadingObserver.send(value: false)
            self.placeholderHiddenObserver.send(value: !self.news.isEmpty)
        }) { (error) in
            self.refreshingObserver.send(value: false)
            self.placeholderHiddenObserver.send(value: !self.news.isEmpty)
        }
    }
}
