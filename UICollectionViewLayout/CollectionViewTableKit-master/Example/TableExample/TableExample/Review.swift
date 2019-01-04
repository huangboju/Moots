//
//  Review.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

struct Review {
    let text: String
    let createdAt: Date
    let author: User
    let image: UIImage?
}

extension Review {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }()

    var createdAtString: String {
        return Review.dateFormatter.string(from: createdAt)
    }

    static let hardcodedReviews: [Review] = [
        Review(
            text: "Great atmosphere and great food. I had the best pasta of my life here. It was full of flavour and didn't want to stop eating. Absolutely delicious!!!! The best meal I had in Berlin.",
            createdAt: Date(),
            author: User(
                name: "Joe Anson",
                avatar: #imageLiteral(resourceName: "joe")
            ),
            image: nil
        ),
        Review(
            text: "Wonderful experience. The staff was friendly and accommodating, the menu simple and unpretentious. The menu changes daily. Be sure to book far in advance, especially on weekends!",
            createdAt: Date(),
            author: User(
                name: "Ryan Thompson",
                avatar: #imageLiteral(resourceName: "ryan")
            ),
            image: nil
        ),
        Review(
            text: "They never got enough tables in summer (which is ok as you can take chairs and sit somewhere on the sidewalk). Very good bar / restaurant with gorgeous food and wine & a lovely atmosphere.",
            createdAt: Date(),
            author: User(
                name: "Laura Cooke",
                avatar: #imageLiteral(resourceName: "laura")
            ),
            image: nil
        ),
        Review(
            text: "All the food was so delicious!!! It's a bit expensive but it is definitely worth it, everything's cooked perfectly. Don't ignore the desserts!",
            createdAt: Date(),
            author: User(
                name: "Jane Odell",
                avatar: #imageLiteral(resourceName: "jane")
            ),
            image: nil
        ),
        Review(
            text: "Great atmosphere and great food. I had the best pasta of my life here. It was full of flavour and didn't want to stop eating. Absolutely delicious!!!! The best meal I had in Berlin.",
            createdAt: Date(),
            author: User(
                name: "Ayo Pearson",
                avatar: #imageLiteral(resourceName: "ayo")
            ),
            image: nil
        ),
        Review(
            text: "Furious chicken has a thinly coated, crisp and flavorful, crust. The meat is tender. Heads up for spice heads: it's not that spicy. Avoid the sweet potato chips,better off with the fries.",
            createdAt: Date(),
            author: User(
                name: "Wonho Riley",
                avatar: #imageLiteral(resourceName: "wonho")
            ),
            image: nil
        ),
        Review(
            text: "Pretty bad. Burger was burnt and fries were soggy with grease and undercooked. Go across the street to Spreegold or further on to The Bird for a much better burger.",
            createdAt: Date(),
            author: User(
                name: "Chrissi Robson",
                avatar: #imageLiteral(resourceName: "chrissi")
            ),
            image: nil
        ),
        Review(
            text: "Ordinary. Go to Stargader burger: better value for money. Or to The Bird if you want to treat yourself!",
            createdAt: Date(),
            author: User(
                name: "Eli Locatelli",
                avatar: #imageLiteral(resourceName: "eli")
            ),
            image: nil
        ),
        Review(
            text: "Good ambience, service, and food. Menu does not offer a lot of variety, though. Bibimbap was good, but PANCAKE WAS AWESOME. Perfect dessert after spicy Korean food!",
            createdAt: Date(),
            author: User(
                name: "Brooke Yarra",
                avatar: #imageLiteral(resourceName: "brooke")
            ),
            image: nil
        ),
    ]
}
