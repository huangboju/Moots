//
//  RequestPluginExample.swift
//  MoyaStudy
//
//  Created by fancy on 2017/4/13.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Foundation
import Moya
import Result

/// show or hide the loading hud
public final class RequestLoadingPlugin: PluginType {
    
    public func willSend(_ request: RequestType, target: TargetType) {
        // show loading
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        // hide loading
    }
    
}

// network logger
public final class NetworkLogger: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {}
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
      //  #if DEBUG
            switch result {
            case .success(let response):
                print(response.request ?? "")
                print(response.response ?? "")
            case .failure(let error):
                print(error)
            }
      //  #endif
    }
}
