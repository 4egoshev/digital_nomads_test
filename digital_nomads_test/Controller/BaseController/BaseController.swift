//
//  BaseController.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit
import ReactiveSwift

class BaseController: UIViewController {
    
    // MARK: Reactive
    let (lifetime, token) = Lifetime.make()
    
    let keyboardHandler = KeyboardHandler()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
