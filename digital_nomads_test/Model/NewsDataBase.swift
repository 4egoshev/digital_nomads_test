//
//  NewsDataBase.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import RealmSwift

class NewsDataBase {
    private let configuration = Realm.Configuration(schemaVersion: 1)
    
    private let queue = DispatchQueue(label: "com.test.database",
                                      qos: .default,
                                      attributes: .concurrent)
    
    func getNews() -> [News] {
        do {
            let realm = try Realm(configuration: configuration)
            let newsRealm = realm.objects(NewsRealm.self)
            var news = [News]()
            Array(newsRealm).forEach {
                news.append(News(news: $0))
            }
            return news
        } catch {
            return []
        }
    }
    
    func update(news: [News]) {
        queue.async {
            self.deleteNews()
            news.forEach {
                self.save($0)
            }
        }
    }
    
    private func save(_ news: News) {
        do {
            let newsRealm = NewsRealm(news: news)
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.add(newsRealm)
            }
        } catch {
            //TODO: handle Error
        }
    }
    
    private func deleteNews() {
        do {
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.delete(realm.objects(NewsRealm.self))
            }
        } catch {
            //TODO: handle Error
        }
    }
}
