//
//  NewsViewModel.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit

class NewsViewModel: BaseViewModel {
    
    private var news = [News]()

    override init() {
        super.init()
        request()
    }
}

//MARK: - TableView
extension NewsViewModel {
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
}

//MARK: - Request
private extension NewsViewModel {
    func request() {
        Networker.shared.sendRequest(.getNews, success: { [weak self] (response: News) in
            self?.news.append(response)
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
}
