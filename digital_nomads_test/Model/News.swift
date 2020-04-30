//
//  News.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import SwiftyJSON

struct Articles<T: JSONDecodable>: JSONDecodable {
    var items: [T] = []
    
    init(json: JSON) {
        if let articles = json["articles"].array {
            articles.forEach { self.items.append(T(json: $0)) }
        }
    }
}

struct News: JSONDecodable {
    var title: String?
    var descript: String?
    var author: String?
    var content: String?
    var date: Date? = nil
    var urlString: String? = nil
    var imageUrlString: String? = nil
    
    init(news: NewsRealm) {
        self.title = news.title
        self.descript = news.descript
        self.author = news.author
        self.content = news.content
        self.date = news.date
        self.urlString = news.urlString
        self.imageUrlString = news.imageUrlString
    }
    
    init(json: JSON) {
        self.title = json["title"].string
        self.descript = json["description"].string
        self.author = json["author"].string
        self.content = json["content"].string
        
        self.date = Utilitis.createDate(from: json["publishedAt"].string)
        
        self.urlString = json["url"].string
        self.imageUrlString = json["urlToImage"].string
    }
    
    static func serializeJSON(theame: String, date: Date, page: Int) -> [String : Any] {
        let from = Utilitis.createString(from: date)
        return ["q"      : theame,
                "from"   : from,
                "sortBy" : "publishedAt",
                "apiKey" : Constant.apiKey,
                "page"   : "\(page)"]
    }
}
