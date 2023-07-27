/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The data model of the Emoji Explorer examples
*/

import UIKit

struct Emoji: Hashable {

    enum Category: CaseIterable, CustomStringConvertible {
        case recents, smileys, nature, food, activities, travel, objects, symbols
    }
    
    let text: String
    let title: String
    let category: Category
    private let identifier = UUID()
}

extension Emoji.Category {
    
    var description: String {
        switch self {
        case .recents: return "Recents"
        case .smileys: return "Smileys"
        case .nature: return "Nature"
        case .food: return "Food"
        case .activities: return "Activities"
        case .travel: return "Travel"
        case .objects: return "Objects"
        case .symbols: return "Symbols"
        }
    }
    
    var emojis: [Emoji] {
        switch self {
        case .recents:
            return [
                Emoji(text: "🤣", title: "Rolling on the floor laughing", category: self),
                Emoji(text: "🥃", title: "Whiskey", category: self),
                Emoji(text: "😎", title: "Cool", category: self),
                Emoji(text: "🏔", title: "Mountains", category: self),
                Emoji(text: "⛺️", title: "Camping", category: self),
                Emoji(text: "⌚️", title: " Watch", category: self),
                Emoji(text: "💯", title: "Best", category: self),
                Emoji(text: "✅", title: "LGTM", category: self)
            ]

        case .smileys:
            return [
                Emoji(text: "😀", title: "Happy", category: self),
                Emoji(text: "😂", title: "Laughing", category: self),
                Emoji(text: "🤣", title: "Rolling on the floor laughing", category: self)
            ]
            
        case .nature:
            return [
                Emoji(text: "🦊", title: "Fox", category: self),
                Emoji(text: "🐝", title: "Bee", category: self),
                Emoji(text: "🐢", title: "Turtle", category: self)
            ]
            
        case .food:
            return [
                Emoji(text: "🥃", title: "Whiskey", category: self),
                Emoji(text: "🍎", title: "Apple", category: self),
                Emoji(text: "🍑", title: "Peach", category: self)
            ]
        case .activities:
            return [
                Emoji(text: "🏈", title: "Football", category: self),
                Emoji(text: "🚴‍♀️", title: "Cycling", category: self),
                Emoji(text: "🎤", title: "Singing", category: self)
            ]

        case .travel:
            return [
                Emoji(text: "🏔", title: "Mountains", category: self),
                Emoji(text: "⛺️", title: "Camping", category: self),
                Emoji(text: "🏖", title: "Beach", category: self)
            ]

        case .objects:
            return [
                Emoji(text: "🖥", title: "iMac", category: self),
                Emoji(text: "⌚️", title: " Watch", category: self),
                Emoji(text: "📱", title: "iPhone", category: self)
            ]

        case .symbols:
            return [
                Emoji(text: "❤️", title: "Love", category: self),
                Emoji(text: "☮️", title: "Peace", category: self),
                Emoji(text: "💯", title: "Best", category: self)
            ]

        }
    }
}
