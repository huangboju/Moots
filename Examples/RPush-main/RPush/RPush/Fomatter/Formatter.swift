//
//  Formatter.swift
//  RPush
//
//  Created by Axe on 2021/1/11.
//

import Foundation

protocol Formatter {
    var deviceToken: String { get }
    var payload: String { get } // JSON
    var formattedDeviceToken: String { get }
    var data: Data { get }
}
