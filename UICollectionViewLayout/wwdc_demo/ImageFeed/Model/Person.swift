/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Model object representing a single person.
*/

import Foundation

enum PersonUpdate {
    case delete(Int)
    case insert(Person, Int)
    case move(Int, Int)
    case reload(Int)
}

struct Person: CustomStringConvertible {
    var name: String?
    var imgName: String?
    var lastUpdate = Date()
    
    init(name: String, month: Int, day: Int, year: Int) {
        self.name = name
        self.imgName = name.lowercased()
        
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        
        if let date = Calendar.current.date(from: components) {
            lastUpdate = date
        }
    }
    
    var isUpdated: Bool? {
        didSet {
            lastUpdate = Date()
        }
    }

    var description: String {
        if let name = self.name {
            return "<\(type(of: self)): name = \(name)>"
        } else {
            return "<\(type(of: self))>"
        }
    }
}
