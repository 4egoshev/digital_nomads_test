//
//  Utilitis.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 27.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import Foundation

class Utilitis {
    static func createDate(from string: String?) -> Date? {
        guard let dateString = string else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: dateString)
    }
}
