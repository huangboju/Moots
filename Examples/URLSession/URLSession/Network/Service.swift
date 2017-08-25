//
//  Service.swift
//  URLSession
//
//  Created by 黄伯驹 on 2017/8/10.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Alamofire

struct Service {
    func request(with urlStr: String, method: HTTPMethod = .get) {
        Alamofire.request(urlStr).response { response in
            
        }
    }
}
