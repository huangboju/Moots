//
//  DebugConfigurable.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 5/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation


/// Support for debug configurations

protocol DebugConfigurable {
    func _configureForDebug<T>(_:T)
}
extension DebugConfigurable {
    func _configureForDebug<T>(_:T){}
}
