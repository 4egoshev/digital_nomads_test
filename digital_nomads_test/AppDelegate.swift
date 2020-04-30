//
//  AppDelegate.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit

weak var app: AppDelegate!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var updateCenter = UpdateCenter.shared
    
    private var coordinator: AppFlowCoordinator?
    
    override init() {
        super.init()
        app = self
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppFlowCoordinator(window: window!)
        coordinator?.start()
        return true
    }
}

