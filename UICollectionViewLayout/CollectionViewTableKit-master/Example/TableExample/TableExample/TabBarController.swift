//
//  TabBarController.swift
//  TableExample
//
//  Created by Malte Schonvogel on 18.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    private let simpleViewController = SimpleViewController()

    private let complexViewController = PlaceDetailViewController()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        simpleViewController.tabBarItem = UITabBarItem(title: "Simple", image: #imageLiteral(resourceName: "first"), tag: 1)
        complexViewController.tabBarItem = UITabBarItem(title: "Complex", image: #imageLiteral(resourceName: "second"), tag: 2)

        viewControllers = [
            complexViewController,
            simpleViewController,
        ].map(UINavigationController.init)
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}
