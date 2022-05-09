//
//  ApiExample.swift
//  MoyaStudy
//
//  Created by fancy on 2017/4/13.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

enum ApiExample {
    case frontpage
    case fetchMorePackageArts(count: Int, artStyleId: Int, artType: Int)
    case updateExample(image: UIImage, otherParameter: String)
}

extension ApiExample: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://zuzu.artally.com.cn/zuzuart/")!
    }
    
    public var path: String {
        switch self {
        case .frontpage:
            return "frontpage/index/list/"
        case .fetchMorePackageArts:
            return "work/banner/work/list10/"
        case .updateExample:
            return "这里不提供实例,使用伪代码"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .frontpage:
            return .get
        case .fetchMorePackageArts, .updateExample:
            return .post
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .frontpage:
            return nil
        case .fetchMorePackageArts(let count, let artStyleId, let artType):
            return ["count": count, "banner_style_id": artStyleId, "type": artType]
        case .updateExample(_, let otherParameter):
            // 这里返回除图片之外的所有参数
            return ["参数名":otherParameter]
        }
    }
    
    // Local data for unit test.use empty data temporarily.
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    // Represents an HTTP task.
    public var task: Task {
        switch self {
        case .updateExample(let image, _):
            let data = UIImageJPEGRepresentation(image, 0.7)
            let img = MultipartFormData(provider: .data(data!), name: "参数名", fileName: "名称随便写.jpg", mimeType: "image/jpeg")
            return .upload(.multipart([img]))
        default:
            return .request
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        // Select type of parameter encoding based on requirements.Usually we use 'URLEncoding.default'.
        /*
        if self.method == .get || self.method == .head {
            return URLEncoding.default
        } else {
            return JSONEncoding.default
        }
        */
        return URLEncoding.default
    }

    
    
    
    
}
