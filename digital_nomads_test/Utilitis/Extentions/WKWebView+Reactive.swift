//
//  WKWebView+Reactive.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import WebKit
import ReactiveSwift

extension Reactive where Base: WKWebView {
    var load: BindingTarget<URLRequest> {
        return makeBindingTarget {
            $0.load($1)
        }
    }
}
