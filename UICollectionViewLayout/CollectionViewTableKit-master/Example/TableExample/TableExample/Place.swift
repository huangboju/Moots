//
//  Place.swift
//  TableExample
//
//  Created by Malte Schonvogel on 26.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit
import MapKit

class Place {

    let title: String
    let cover: UIImage
    let webUrl: URL
    let phoneNumber: String
    let location: CLLocation
    let address: String
    var reviews: [Review]
    var images: [UIImage]

    init(title: String, cover: UIImage, webUrl: URL, phoneNumber: String, location: CLLocation, address: String, reviews: [Review], images: [UIImage]) {

        self.title = title
        self.cover = cover
        self.webUrl = webUrl
        self.phoneNumber = phoneNumber
        self.location = location
        self.address = address
        self.reviews = reviews
        self.images = images
    }
}

extension Place {

    static let hardcodedPlace = Place(
        title: "Korean BBQ & Burgers",
        cover: #imageLiteral(resourceName: "header"),
        webUrl: URL(string: "https://bbq-burgers.com")!,
        phoneNumber: "004930123456789",
        location: CLLocation(latitude: 52.5023135, longitude: 13.4245037),
        address: "Mariannenstr. 54, 10999 Berlin",
        reviews: Review.hardcodedReviews,
        images: [
            #imageLiteral(resourceName: "lisboa"),
            #imageLiteral(resourceName: "martinez"),
            #imageLiteral(resourceName: "burger"),
            #imageLiteral(resourceName: "heftiba"),
            #imageLiteral(resourceName: "pizza"),
            #imageLiteral(resourceName: "burger2"),
            #imageLiteral(resourceName: "sandwich"),
            #imageLiteral(resourceName: "soup")
        ]
    )
}
