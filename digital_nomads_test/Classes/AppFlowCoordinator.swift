//
//  AppFlowCoordinator.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit

class AppFlowCoordinator {
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let dataBase = NewsDataBase()
        let news = dataBase.getNews()
        print("news = \(news.count)")
        
        let viewModel = NewsViewModel(news: news)
        let controller = NewsController(viewModel: viewModel)
        
        window.makeKeyAndVisible()
        window.rootViewController = UINavigationController(rootViewController: controller)
    }
}
