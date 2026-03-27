//
//  PushHistoryRecord.swift
//  RPush
//

import Foundation

struct PushHistoryRecord: Codable {
    let id: String
    let date: Date
    let deviceToken: String
    let payload: String
    let authMethod: String     // "certificate" or "token"
    let environment: String    // "development" or "production"
    let bundleId: String?
    let keyId: String?
    let teamId: String?
    let isSuccess: Bool
    
    init(deviceToken: String,
         payload: String,
         authMethod: AuthenticationMethod,
         environment: Environment,
         bundleId: String? = nil,
         keyId: String? = nil,
         teamId: String? = nil,
         isSuccess: Bool) {
        self.id = UUID().uuidString
        self.date = Date()
        self.deviceToken = deviceToken
        self.payload = payload
        self.authMethod = authMethod == .certificateBased ? "certificate" : "token"
        self.environment = environment == .delelopment ? "development" : "production"
        self.bundleId = bundleId
        self.keyId = keyId
        self.teamId = teamId
        self.isSuccess = isSuccess
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    var shortPayload: String {
        if payload.count > 60 {
            return String(payload.prefix(60)) + "..."
        }
        return payload
    }
    
    var authMethodEnum: AuthenticationMethod {
        return authMethod == "certificate" ? .certificateBased : .tokenBased
    }
    
    var environmentEnum: Environment {
        return environment == "development" ? .delelopment : .production
    }
}
