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
        window.makeKeyAndVisible()
        let controller = NewsController()
        window.rootViewController = UINavigationController(rootViewController: controller)
    }
}
