//
//  Observable+ObjectMapper.swift
//  MoyaStudy
//
//  Created by fancy on 2017/4/13.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension Observable {
    func mapObject<T: Mappable>(type: T.Type, key: String? = nil) -> Observable<T> {
        return self.map { response in
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            if let error = self.parseError(response: dict) {
                throw error
            }
            if let k = key {
                guard let dictionary = dict[k] as? [String: Any] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                return Mapper<T>().map(JSON: dictionary)!
            }
            return Mapper<T>().map(JSON: dict)!
        }
    }

    func mapArray<T: Mappable>(type: T.Type, key: String? = nil) -> Observable<[T]> {
        return self.map { response in
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            if let error = self.parseError(response: dict) {
                throw error
            }
            if key != nil {
                guard let dictionary = dict[key!] as? [[String: Any]] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                return Mapper<T>().mapArray(JSONArray: dictionary)!
            } else {
                guard let array = response as? [Any] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                guard let dicts = array as? [[String: Any]] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                return Mapper<T>().mapArray(JSONArray: dicts)!
            }
        }
    }
    
    func parseServerError() -> Observable {
        return self.map { (response) in
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            if let error = self.parseError(response: dict) {
                throw error
            }
            return self as! Element
        }
        
    }
    
    fileprivate func parseError(response: [String: Any]?) -> NSError? {
        var error: NSError?
        if let value = response {
            if let code = value["code"] as? Int, code != 200 {
                var msg = ""
                if let message = value["error"] as? String {
                    msg = message
                }
                error = NSError(domain: "Network", code: code, userInfo: [NSLocalizedDescriptionKey: msg])
            }
        }
        return error
    }
    
}

enum RxSwiftMoyaError: String {
    case ParseJSONError
    case OtherError
}


extension RxSwiftMoyaError: Swift.Error {}

