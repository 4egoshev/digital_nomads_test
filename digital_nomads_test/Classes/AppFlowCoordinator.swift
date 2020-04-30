//
//  AppFlowCoordinator.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit

class AppFlowCoordinator {
    private var reachability: Reachability?
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let dataBase = NewsDataBase()
        let news = dataBase.getNews()
        let viewModel = NewsViewModel(news: news)
        let controller = NewsController(viewModel: viewModel)
        
        reachability = try? Reachability(hostname: "www.google.com")
        
        window.makeKeyAndVisible()
        window.rootViewController = UINavigationController(rootViewController: controller)
    }
}
