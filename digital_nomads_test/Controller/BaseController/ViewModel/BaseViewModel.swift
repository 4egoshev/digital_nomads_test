//
//  BaseViewModel.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import ReactiveSwift

class BaseViewModel {
    // MARK: Reactive
    let (lifetime, token) = Lifetime.make()
}
