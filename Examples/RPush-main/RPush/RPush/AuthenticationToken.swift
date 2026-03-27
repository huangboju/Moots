//
//  AuthenticationToken.swift
//  RPush
//
//  Created by Axe on 2021/1/11.
//

import Foundation

/**
 Communicate with APNs using authentication tokens.
 
 * After you create the token, you must sign it with a private key. You must then encrypt the token using the Elliptic Curve Digital Signature Algorithm (ECDSA) with the P-256 curve and the SHA-256 hash algorithm. Specify the value ES256 in the algorithm header key (alg).
 
 * [Docs] (https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1)
 */
class AuthenticationToken {
        
    /// Your private key ID from App Store Connect (Ex: 2X9R4HXF34)
    /// A 10-character key identifier (kid) key, obtained from your developer account.
    private let keyId: String
    
    /// The issuer (iss) registered claim key, whose value is your 10-character Team ID, obtained from your developer account
    private let teamId: String
        
    private var cachedToken: JWT.Token?
        
    /// The JWT Creator to use for creating the JWT token. Can be overriden for test use cases.
    private let jwtCreator: JWTCreatable
    
    init(keyId: String, teamId: String) {
        self.keyId = keyId
        self.teamId = teamId
        self.jwtCreator = JWT(keyIdentifier: keyId, issuerIdentifier: teamId, expireDuration: 60 * 10)
    }
    
    /// Generates a new JWT Token from .p8 file, but only if the in memory cached one is not expired.
    func generateJWTToken(fromP8 path: String) throws -> JWT.Token {
        if let cachedToken = cachedToken, !cachedToken.isExpired {
            return cachedToken
        }
        
        let privateKey = try P8.getPrivateKey(fromP8: path)
        let token = try jwtCreator.signedToken(using: privateKey)
        cachedToken = token
        
        return token
    }
    
    /// Generates a new JWT Token from p8 private key string, but only if the in memory cached one is not expired.
    func generateJWTToken(fromP8PrivateKey privateKey: String) throws -> JWT.Token {
        if let cachedToken = cachedToken, !cachedToken.isExpired {
            return cachedToken
        }
        
        let token = try jwtCreator.signedToken(using: privateKey)
        cachedToken = token
        
        return token
    }
    
}
