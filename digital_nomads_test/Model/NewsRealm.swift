//
//  NewsRealm.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import RealmSwift

class NewsRealm: Object {
    @objc dynamic var title: String? = nil
    @objc dynamic var descript: String? = nil
    @objc dynamic var author: String? = nil
    @objc dynamic var content: String? = nil;
    @objc dynamic var date: Date? = nil
    @objc dynamic var urlString: String? = nil
    @objc dynamic var imageUrlString: String? = nil
    
    convenience init(news: News) {
        self.init()
        self.title = news.title
        self.descript = news.descript
        self.author = news.author
        self.content = news.content
        self.date = news.date
        self.urlString = news.urlString
        self.imageUrlString = news.imageUrlString
    }
}
