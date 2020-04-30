//
//  NewsDetailViewModel.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import ReactiveSwift
import Result

class NewsDetailViewModel: BaseViewModel {
    
    let load: Signal<URLRequest, NoError>
    private let loadObserver: Signal<URLRequest, NoError>.Observer
    
    let presentViewController: Signal<UIViewController, NoError>
    private let presentViewControllerObserver: Signal<UIViewController, NoError>.Observer
    
    private let url: URL

    init(url: URL) {
        self.url = url
        
        (load, loadObserver) = Signal.pipe()
        (presentViewController, presentViewControllerObserver) = Signal.pipe()
        
        super.init()
        bind()
    }
    
    private func bind() {
        update <~ app.updateCenter.update
    }
}

//MARK: - Reactive
private extension NewsDetailViewModel {
    var update: BindingTarget<UpdateEvent> {
        return BindingTarget(lifetime: lifetime) { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .online(let online):
                guard online else {
                    self.createDisconnectionAlert()
                    return
                }
                self.loadObserver.send(value: self.request)
            }
        }
    }
}

//MARK: - Get
extension NewsDetailViewModel {
    var request: URLRequest {
        return URLRequest(url: url)
    }
}

//MARK: - Private
private extension NewsDetailViewModel {
    func createDisconnectionAlert() {
        let alert = AlertHandler.errorAlert(message: "Low speed internet connection")
        presentViewControllerObserver.send(value: alert)
    }
}
