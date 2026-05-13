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
 
 * APNs accepts a provider token for up to 60 minutes after `iat`, and rejects new tokens that are
   issued less than 20 minutes after the previous one with `TooManyProviderTokenUpdates`. This
   class enforces both constraints by caching the most recent JWT and re-signing only when it has
   aged past ``minRefreshInterval``.
 
 * [Docs] (https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1)
 */
final class AuthenticationToken {

    /// Apple rejects refreshes faster than once every 20 minutes; we wait a bit longer to be safe.
    /// This also stays comfortably below Apple's 60-minute hard expiry.
    static let minRefreshInterval: TimeInterval = 50 * 60

    /// Your private key ID from App Store Connect (Ex: 2X9R4HXF34)
    /// A 10-character key identifier (kid) key, obtained from your developer account.
    let keyId: String

    /// The issuer (iss) registered claim key, whose value is your 10-character Team ID, obtained from your developer account
    let teamId: String

    private var cachedToken: JWT.Token?
    private var cachedTokenIssuedAt: Date?

    init(keyId: String, teamId: String) {
        self.keyId = keyId
        self.teamId = teamId
    }

    /// Generates a JWT Token from a .p8 file path, reusing the in-memory cached one when possible.
    func generateJWTToken(fromP8 path: String) throws -> JWT.Token {
        if let token = cachedValidToken() {
            return token
        }
        let privateKey = try P8.getPrivateKey(fromP8: path)
        return try signAndCache(privateKey: privateKey)
    }

    /// Generates a JWT Token from a .p8 private key string, reusing the in-memory cached one when possible.
    func generateJWTToken(fromP8PrivateKey privateKey: String) throws -> JWT.Token {
        if let token = cachedValidToken() {
            return token
        }
        return try signAndCache(privateKey: privateKey)
    }

    /// Drops any cached token, forcing the next call to re-sign. Use this when the underlying
    /// key material changes (different .p8 / Key ID / Team ID).
    func invalidate() {
        cachedToken = nil
        cachedTokenIssuedAt = nil
    }

    private func cachedValidToken() -> JWT.Token? {
        guard let token = cachedToken, let issuedAt = cachedTokenIssuedAt else {
            return nil
        }
        // Keep using the same JWT until it is close to APNs's 60-minute expiry. Re-signing earlier
        // would risk hitting `TooManyProviderTokenUpdates`.
        if Date().timeIntervalSince(issuedAt) < AuthenticationToken.minRefreshInterval {
            return token
        }
        return nil
    }

    private func signAndCache(privateKey: JWT.P8PrivateKey) throws -> JWT.Token {
        // Always use a fresh JWT instance so `iat` reflects the actual signing moment.
        let jwt = JWT(keyIdentifier: keyId, issuerIdentifier: teamId)
        let token = try jwt.signedToken(using: privateKey)
        cachedToken = token
        cachedTokenIssuedAt = jwt.issuedAt
        return token
    }
}
