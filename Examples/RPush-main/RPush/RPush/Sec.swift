//
//  Sec.swift
//  RPush
//
//  Created by Axe on 2021/1/5.
//

import Foundation

enum Environment {
    case delelopment
    case production
}

enum AuthenticationMethod {
    case certificateBased
    case tokenBased
}

struct Sec {
    let certificate: SecCertificate
    let name: String?
    var key: String?
    let date: Date?
    let expire: String
    
    init(secCertificate: SecCertificate) {
        self.certificate = secCertificate
        self.name = secCertificate.subjectSummary
        self.key = name
        self.date = secCertificate.expireDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = date != nil ? dateFormatter.string(from: date!) : "expired"
        self.expire = "  " + "[\(dateString)]"
    }
}

struct SecManager {
    
    static func fetchAllPushCertificates(withEnvironment: Environment) -> [Sec] {
        let allCerts = fetchAllCertificatesFromKeychain()
        let result = allCerts
            .compactMap { Sec(secCertificate: $0) }
            .filter { SecManager.isPushCertificate(by: $0.name ?? "") }
        return result
    }
    
    static func isPushCertificate(by name: String) -> Bool {
        let opts = [
            "Apple Development IOS Push Services:",
            "Apple Production IOS Push Services:",
            "Apple Development Mac Push Services:",
            "Apple Production Mac Push Services:",
            "Apple Push Services:",
            "Website Push ID:",
            "VoIP Services:",
            "WatchKit Services:"
        ]
        
        return !opts.filter { name.contains($0) }.isEmpty
    }
    
    static func fetchAllCertificatesFromKeychain() -> [SecCertificate] {
        let opts = [
            String(kSecClass): String(kSecClassCertificate),
            String(kSecMatchLimit): String(kSecMatchLimitAll)
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(opts as CFDictionary, &result)
        
        guard status == errSecSuccess, let certs = result as? [SecCertificate] else {
            return []
        }
        
        return certs
    }
    
    static func fetchCertificate(from path: String) throws -> SecCertificate? {
        let filePath = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: filePath)
        let certificate = SecCertificateCreateWithData(nil, data as CFData)
        return certificate
    }
    
}

extension SecCertificate {
    
    fileprivate var subjectSummary: String? {
        return SecCertificateCopySubjectSummary(self) as String?
    }
    
    fileprivate var expireDate: Date? {
        return valueForKey(kSecOIDInvalidityDate as String) as? Date
    }

    var isPush: Bool {
        return SecManager.isPushCertificate(by: subjectSummary ?? "")
    }
    
    var identity: SecIdentity? {
        // Open keychain
        var keychain: SecKeychain?
        SecKeychainCopyDefault(&keychain)
        
        // Create SecIdentityRef
        var secIdentity: SecIdentity?
        SecIdentityCreateWithCertificate(keychain, self, &secIdentity)
        
        return secIdentity
    }
    
    private func valueForKey(_ key: String) -> Any? {
        guard let values = valuesForKeys([key]) else {
            return nil
        }
        guard let pair = values[key as CFString] as? [CFString: Any]  else {
            return nil
        }
        let value = pair[kSecPropertyKeyValue]
        return value
    }
    
    private func valuesForKeys(_ keys: [String]) -> [CFString: Any]? {
        return SecCertificateCopyValues(self, keys as CFArray, nil) as? [CFString: Any]
    }
    
}
