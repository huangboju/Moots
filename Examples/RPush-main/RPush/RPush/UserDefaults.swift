//
//  UserDefaults.swift
//  RPush
//
//  Created by Axe on 2021/1/7.
//

import Foundation

extension UserDefaults {
    
    static let deviceTokenKey: String = "KEY_DEVICE_TOKEN"
    static let payloadKey: String = "KEY_PAYLOAD"
    
    enum CertificateAuthInfoKey: String {
        case cerName = "KEY_CER_NAME"
        case cerPath = "KEY_CER_PATH"
    }
    
    enum JSONWebTokenAuthInfoKey: String {
        case bundleId = "KEY_BUNDLE_ID"
        case keyId = "KEY_KEY_ID"
        case teamId = "KET_TEAM_ID"
        case p8FilePath = "KEY_P8_FILE_PATH"
        case p8PrivateKey = "KEY_P8_PRIVATE_KEY"
    }
    
    func setString(_ string: String?, forKey key: String) {
        guard let input = string, !input.isEmpty else {
            removeObject(forKey: key)
            return
        }
        set(input as NSString, forKey: key)
    }
    
    func getString(forKey key: String) -> String? {
        return value(forKey: key) as? String
    }
    
}
