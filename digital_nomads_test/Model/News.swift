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
    let title: String?
    let description: String?
    let author: String?
    let content: String?
    var date: Date? = nil
    var url: URL? = nil
    var imageUrl: URL? = nil
    
    init(json: JSON) {
        self.title = json["title"].string
        self.description = json["description"].string
        self.author = json["author"].string
        self.content = json["content"].string
        
        self.date = Utilitis.createDate(from: json["publishedAt"].string)
        
        if let urlString = json["url"].string {
            self.url = URL(string: urlString)
        }
        if let urlString = json["urlToImage"].string {
            self.imageUrl = URL(string: urlString)
        }
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
