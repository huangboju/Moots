//
//  ChangesRecorder.swift
//  UndoAppExample
//
//  Created by Tomasz Szulc on 13/09/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

class ChangesRecorder {
    typealias Key = String
    typealias Value = Any
    
    var dictionary: [String: Any] = [:]
    
    func setValue(for key: Key, value: Value?) {
        dictionary[key] = value
    }
    
    func value(for key: Key) -> Value? {
        return dictionary[key]
    }
    
    func reset() {
        dictionary.removeAll()
    }
}
