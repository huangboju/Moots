//
//  NSURLSessionNetworkImageService.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 9/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Implementation of the NetworkImageService protocol using NSURLSession

struct NSURLSessionNetworkImageService: NetworkImageService  {
    // MARK: - ImageService
    func requestImage(urlString: String, completion: @escaping (Result<UIImage>) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion( Result.Failure( NetworkError.CannotConnectToServer ) )
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    return completion( Result.Failure( NetworkError.NetworkRequestFailed ) )
                }
                guard let data = data, let image = UIImage(data: data) else {
                    return completion( Result.Failure( NetworkError.ContentValidationFailed ) )
                }
                completion(Result.Success(image))
            }
        }.resume()
    }
}

