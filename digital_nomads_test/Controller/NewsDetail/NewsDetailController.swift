//
//  NewsDetailController.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import WebKit
import ReactiveSwift

class NewsDetailController: BaseController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var loadIndicator: UIActivityIndicatorView!
    
    private let viewModel: NewsDetailViewModel
    
    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        bind()
    }
    
    private func bind() {
        webView.reactive.load <~ viewModel.load
        reactive.presentViewController(animated: true) <~ viewModel.presentViewController
    }
}

//MARK: - Setup
private extension NewsDetailController {
    func setupWebView() {
        webView.navigationDelegate = self
        webView.load(viewModel.request)
    }
}

//MARK: - WKUIDelegate
extension NewsDetailController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadIndicator.stopAnimating()
    }
}
