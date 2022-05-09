//
//  NetworkImageService.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Image Service protocol

protocol NetworkImageService {
    /// given a URL string, fetch an image or an error) and
    /// provides it to the completion closure enclosed in Result
    func requestImage(urlString: String, completion: @escaping (Result<UIImage>) -> Void)
}
