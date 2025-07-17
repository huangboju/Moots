//
//  DateExtension.swift
//  SiriWave
//
//  Created by politom on 09/03/2019.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
