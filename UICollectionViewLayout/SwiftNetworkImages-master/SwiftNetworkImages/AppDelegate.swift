//
//  AppDelegate.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//


import UIKit

/// The App Delegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                                     launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds).configure {
            $0.backgroundColor = .white
            $0.rootViewController = configureTopViewController()
            $0.makeKeyAndVisible()
        }
        return true
    }
}

extension AppDelegate {    
    /// Configures top level view controller and its dependencies
    func configureTopViewController() -> UIViewController {
        
        // Images info loader
        let imagesInfoLoader = ImagesInfoLoader()
        
        // Network image service
        let imageService = NSURLSessionNetworkImageService()
        var imageFetcher = ImageFetcher()
        imageFetcher.inject(imageService)
        
        // Images info data source
        var imagesDataSource = ImagesDataSource()
        imagesDataSource.inject((imagesInfoLoader, imageFetcher))
        
        // Delegate / Data Source for the collection view
        let dataSourceDelegate = SampleImagesDataSourceDelegate()
        
        // Top-level view controller
        let viewController = SampleImagesViewController()
        dataSourceDelegate.inject((imagesDataSource, viewController))
        
        viewController.inject(dataSourceDelegate)
        return viewController
    }
}












