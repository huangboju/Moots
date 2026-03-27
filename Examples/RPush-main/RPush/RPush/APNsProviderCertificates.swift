//
//  APNsProviderCertificates.swift
//  RPush
//
//  Created by Axe on 2021/1/11.
//

import Foundation

/// Communicate with APNs using a TLS certificate
class APNsProviderCertificates {
    
    let deviceToken: String
    let payload: String
    
    private let enhancedNotificationFormat: EnhancedNotificationFormat
    
    init(deviceToken: String, payload: String) {
        self.deviceToken = deviceToken
        self.payload = payload
        self.enhancedNotificationFormat = EnhancedNotificationFormat(deviceToken: deviceToken, payload: payload)
    }
    
    var data: Data {
        return enhancedNotificationFormat.data
    }
    
    var formattedDeviceToken: String {
        return enhancedNotificationFormat.formattedDeviceToken
    }
}
