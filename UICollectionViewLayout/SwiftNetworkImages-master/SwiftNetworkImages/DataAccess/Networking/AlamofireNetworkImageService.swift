//
//  AlamofireNetworkImageService.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

/// Implementation of the NetworkImageService protocol using Alamofire

struct AlamofireNetworkImageService: NetworkImageService  {
    /// given a URL string, fetch an image or an error) and
    /// provides it to the completion closure enclosed in Result
    // MARK: - ImageService
    func requestImage(urlString: String, completion: @escaping (Result<UIImage>) -> Void) {
        Alamofire.request(urlString).responseImage {
            if $0.result.error != nil {
                return completion( Result.Failure( NetworkError.NetworkRequestFailed ) )
            }
            guard let image: UIImage = $0.result.value else {
                return completion( Result.Failure( NetworkError.ContentValidationFailed ) )
            }
            completion(Result.Success(image))
        }
    }
}


