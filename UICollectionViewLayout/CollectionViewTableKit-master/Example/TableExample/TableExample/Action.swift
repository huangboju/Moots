//
//  Action.swift
//  TableExample
//
//  Created by Malte Schonvogel on 24.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

enum Action {

    case save
    case checkIn
    case rate
    case share
    case openWebsite(URL)
    case copyWebsiteUrl(URL)
    case moreInfo
    case call(String)
    case address(String)

    var title: String {
        switch self {
        case .save:
            return "Save"
        case .checkIn:
            return "Check In"
        case .rate:
            return "Rate"
        case .share:
            return "Share"
        case .openWebsite:
            return "Website"
        case .copyWebsiteUrl:
            return "Copy website url"
        case .moreInfo:
            return "More Info"
        case .call:
            return "Call"
        case .address:
            return "Address"
        }
    }

    var subtitle: String? {
        switch self {
        case .save, .checkIn, .rate, .share, .copyWebsiteUrl:
            return nil
        case .openWebsite(let url):
            return url.absoluteString
        case .moreInfo:
            return "Stop, opening hours, website"
        case .call(let phoneNumber):
            return phoneNumber
        case .address(let address):
            return address
        }
    }

    var icon: UIImage? {
        switch self {
        case .save:
            return #imageLiteral(resourceName: "save")
        case .checkIn:
            return #imageLiteral(resourceName: "checkin")
        case .rate:
            return #imageLiteral(resourceName: "star")
        case .share:
            return #imageLiteral(resourceName: "share")
        case .openWebsite:
            return #imageLiteral(resourceName: "safari")
        case .copyWebsiteUrl:
            return #imageLiteral(resourceName: "copy")
        case .moreInfo:
            return #imageLiteral(resourceName: "pluscircle")
        case .call:
            return #imageLiteral(resourceName: "phone")
        case .address:
            return #imageLiteral(resourceName: "location")
        }
    }
}
