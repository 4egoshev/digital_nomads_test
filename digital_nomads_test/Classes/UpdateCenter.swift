//
//  UpdateCenter.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import ReactiveSwift
import Result

enum UpdateEvent {
    case online(_ online: Bool)
}

typealias UpdateSignal = Signal<UpdateEvent, NoError>

protocol UpdateCenterObserving: class {
    var update: UpdateSignal { get }
}

protocol UpdateCenterBroadcasting: class {
    func broadcast(update: UpdateEvent)
}

class UpdateCenter: UpdateCenterObserving, UpdateCenterBroadcasting {
    static var shared = UpdateCenter()
    
    let update: UpdateSignal
    fileprivate let updateObserver: UpdateSignal.Observer
    
    private init() {
        (update, updateObserver) = UpdateSignal.pipe()
    }
    
    func broadcast(update: UpdateEvent) {
        updateObserver.send(value: update)
    }
}
