//
//  NoInternetConnectionRoute.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

protocol NoInternetConnectionRoute {
    func openNoInternetConnectionAlert()
}

extension NoInternetConnectionRoute where Self: RouterProtocol {
    
    func openNoInternetConnectionAlert() {
        let alertViewController = UIAlertController(title: "Title", message: "No internet connection", preferredStyle: .alert)
        viewController?.present(alertViewController, animated: true, completion: nil)
    }
}
