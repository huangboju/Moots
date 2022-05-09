//
//  NetworkError.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 2/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

/// Base implementation of ```CustomErrorConvertible``` for a network request error

enum NetworkError: Int, CustomErrorConvertible {    
    case Unknown                    = -5000
    case NetworkRequestFailed       = -5001
    case ContentValidationFailed    = -5002
    case CannotConnectToServer      = -5003
    
    func errorCode() -> Int {
        return self.rawValue
    }
    
    var description: String  {
        switch self {
        case .Unknown:
            return NSLocalizedString("NetworkErrorUnknown", comment: "Unknown Network Error")
            
        case .NetworkRequestFailed:
            return NSLocalizedString("NetworkErrorRequestFailed", comment: "Network Request Failed")

        case .ContentValidationFailed:
            return NSLocalizedString("NetworkErrorContentValidationFailed",
                                     comment: "Failed to validate response due to unexpected content type")
            
        case .CannotConnectToServer:
            return NSLocalizedString("NetworkErrorCannotConnectToServer",
                                    comment: "Could not connect to the server")
        }
    }
}

extension NetworkError {
    /// translates NSError into NetworkError
    init(error: NSError) {
        guard error.domain == NSURLErrorDomain else {
            self = .NetworkRequestFailed
            return
        }
        switch error.code {
        case NSURLErrorUnknown:
            self = .Unknown
        case  NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData:
            self = .ContentValidationFailed
        case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
            self = .CannotConnectToServer
        default:
            self = .NetworkRequestFailed
        }
    }
}









