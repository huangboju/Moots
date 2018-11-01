//
//  DependencyInjectable.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 8/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

/** Base DI protocol.
    
    Sample Usage:
 
    ```
    extension SampleImagesDataSourceDelegate: DependencyInjectable {
         // MARK: - 🔌Dependencies injection
         func inject(_ imagesDataSource: ImagesDataSource) {
         }
    }
    ``` 
**/

protocol DependencyInjectable {
    associatedtype T

    mutating func inject(_: T)
}
