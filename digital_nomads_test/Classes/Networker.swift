//
//  Networker.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 26.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol JSONDecodable {
    init(json: JSON)
}

class Networker {
    static var shared = Networker()
    
    typealias FailureCompletion = (Error) -> Void
    
    private var isLogEnable = true
    
    private let queue = DispatchQueue(label: "com.test.request",
                                      qos: .default,
                                      attributes: .concurrent)
    
    func sendRequest<T: JSONDecodable>(_ urlRequest: Router,
                                       success: @escaping (T) -> Void,
                                       failure: ((Error?) -> Void)? = nil) {
        request(urlRequest).validate().responseJSON { (response) in
            self.logResponse(response)
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let object = T(json: json)
                success(object)
            case .failure(let error):
                failure?(error)
            }
        }
    }

    //MARK: - Logs
    private func logResponse(_ response: DataResponse<Any>) {
        if isLogEnable {
            print("-------------------------")
            if let request = response.request {
                print("REQUEST: \(request)")
            }
            if let method = response.request?.httpMethod {
                print("METHOD: \(method)")
            }
            if let header = response.request?.allHTTPHeaderFields {
                print("HEADER: \(header)")
            }
            if let params = response.request?.httpBody {
                if let paramsString = String(bytes: params, encoding: .utf8) {
                    print("PARAMETRS: \(paramsString)")
                }
            }
            if let response = response.response {
                print("STATUS CODE: \(response.statusCode)")
            }
            print(response.description)
            print("-------------------------")
        }
    }
}
