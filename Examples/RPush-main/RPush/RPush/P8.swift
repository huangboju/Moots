//
//  P8.swift
//  RPush
//
//  Created by Axe on 2021/3/2.
//

import Foundation

struct P8 {
    
    static func getPrivateKey(fromP8 path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        
        guard let token = String(data: data, encoding: .utf8) else {
            print("Data编码失败")
            throw JWT.Error.invalidP8PrivateKey
        }
        
        let privateKey = token.replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
        .replacingOccurrences(of: "\r", with: "")
        .replacingOccurrences(of: "\n", with: "")
        .replacingOccurrences(of: "\t", with: "")
        .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
        .replacingOccurrences(of: " ", with: "")
        
        return privateKey
    }
    
    private init() {}
}
