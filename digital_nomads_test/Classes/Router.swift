//
//  Router.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import Alamofire

fileprivate let host = "https://newsapi.org"

enum Router: URLRequestConvertible {

    private var basePath: String {
        return host + "/v2"
    }
    
    case getNews(theame: String, date: Date, page: Int)
    
    private var methodPath: String {
        switch self {
        case .getNews:
            return "/everything"
        }
    }
    
    private var mathod: HTTPMethod {
        switch self {
        case .getNews:
            return .get
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
        case .getNews:
            return URLEncoding.queryString
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getNews(let theame, let date, let page):
            return ["q"      : theame,
                    "from"   : "2020-04-25",
                    "sortBy" : "publishedAt",
                    "apiKey" : "a3d97a3a99c44160a7265905c58c2c7d",
                    "page"   : "\(page)"]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try basePath.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(methodPath))
        urlRequest.httpMethod = mathod.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = 60
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return try encoding.encode(urlRequest, with: parameters)
    }
}
