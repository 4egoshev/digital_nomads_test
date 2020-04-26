//
//  Array+Extentions.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 27.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import SwiftyJSON

extension Array: JSONDecodable where Element: JSONDecodable {
    init(json: JSON) {
        self = []
        guard let array = json.array else {return}
        for json in array {
            self.append(Element(json: json))
        }
    }
}
