//
//  JWT.swift
//  AppStoreConnect-Swift-SDK
//
//  Created by Antoine van der Lee on 08/11/2018.
//

import Foundation

/// The JWT Header contains information specific to the App Store Connect API Keys, such as algorithm and keys.
private struct Header: Codable {

    enum CodingKeys: String, CodingKey {
        case algorithm = "alg"
        case keyIdentifier = "kid"
    }
    
    /// All JWTs for App Store Connect API must be signed with ES256 encryption
    let algorithm: String = "ES256"

    /// Your private key ID from App Store Connect (Ex: 2X9R4HXF34)
    let keyIdentifier: String
}

/// The JWT Payload for APNs.
///
/// Per Apple's documentation, the APNs provider JWT must contain `iss` (Team ID) and `iat`
/// (the time at which the token was issued, in seconds since the Unix epoch). APNs treats the
/// token as valid for up to one hour after `iat` and rejects providers that update the token
/// faster than once every 20 minutes (`TooManyProviderTokenUpdates`).
private struct Payload: Codable {

    enum CodingKeys: String, CodingKey {
        case issuerIdentifier = "iss"
        case issuedAt = "iat"
    }

    /// Your 10-character Team ID, obtained from your developer account.
    let issuerIdentifier: String

    /// The token's issuance time, in Unix epoch seconds.
    let issuedAt: TimeInterval
}

protocol JWTCreatable {
    /// The instant this JWT was issued. Used to enforce APNs's refresh window.
    var issuedAt: Date { get }
    func signedToken(using privateKey: JWT.P8PrivateKey) throws -> JWT.Token
}

struct JWT: JWTCreatable {

    public enum Error: Swift.Error, LocalizedError {

        /// In case the provided .p8 private key is of an invalid format.
        case invalidP8PrivateKey

        /// In case the private key could not be converted using the EC Algoritm
        case privateKeyConversionFailed

        /// In case the ES256 signing failed with the given digest containing the header and payload.
        case ES256SigningFailed

        /// In case the ASN1 could not be generated.
        case invalidASN1

        public var localizedDescription: String {
            switch self {
            case .invalidP8PrivateKey:
                return "The provided .p8 private key is of an invalid format"
            case .privateKeyConversionFailed:
                return "Something went wrong with converting the private key"
            case .ES256SigningFailed:
                return "Signing the digest containing the header and payload failed using the ES256 algorithm"
            case .invalidASN1:
                return "Failed to generate the ASN1 value out of the private key"
            }
        }
    }
    
    typealias Token = String
    typealias P8PrivateKey = String

    /// The JWT Header.
    private let header: Header

    /// The JWT Payload.
    private let payload: Payload

    /// The instant this JWT was issued (the value used for the `iat` claim).
    let issuedAt: Date

    /// Creates a new JWT factory for signing APNs provider authentication tokens.
    ///
    /// - Parameters:
    ///   - keyIdentifier: Your 10-character Key ID, obtained from your developer account (Ex: 2X9R4HXF34).
    ///   - issuerIdentifier: Your 10-character Team ID, obtained from your developer account.
    ///   - issuedAt: The instant to use for the `iat` claim. Defaults to "now".
    public init(keyIdentifier: String, issuerIdentifier: String, issuedAt: Date = Date()) {
        self.header = Header(keyIdentifier: keyIdentifier)
        self.issuedAt = issuedAt
        self.payload = Payload(issuerIdentifier: issuerIdentifier, issuedAt: issuedAt.timeIntervalSince1970)
    }

    /// Combine the header and the payload as a digest for signing.
    private func digest() throws -> String {
        let headerData = try JSONEncoder().encode(header.self)
        let payloadData = try JSONEncoder().encode(payload.self)
        let headerString = headerData.base64URLEncoded()
        let payloadString = payloadData.base64URLEncoded()
        return "\(headerString).\(payloadString)"
    }

    /// Creates a signed JWT Token which can be used as a Bearer Authentication header value for signing App Store Connect API Requests.
    ///
    /// - Parameter privateKey: The .p8 private key to use for signing. You can get this value from the downloaded .p8 file.
    /// - Returns: A signed JWT.Token value which can be used as a value for the Bearer Authentication header.
    /// - Throws: An error if something went wrong, like a JWT.Error.
    public func signedToken(using privateKey: P8PrivateKey) throws -> JWT.Token {
        let digest = try self.digest()

        let signature = try privateKey.toASN1()
            .toECKeyData()
            .toPrivateKey()
            .es256Sign(digest: digest)

        return "\(digest).\(signature)"
    }
}

internal extension Data {

    /// Encodes the data using base64.
    ///
    /// - Returns: A base64 encoded `String`.
    func base64URLEncoded() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}

internal extension String {
    func base64URLDecoded() -> String {
        var base64 = replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return base64
    }
}

private extension JWT.P8PrivateKey {

    /// Converts the PEM formatted .p8 private key to a DER-encoded ASN.1 data object.
    func toASN1() throws -> ASN1 {
        guard let asn1 = Data(base64Encoded: self) else {
            throw JWT.Error.invalidP8PrivateKey
        }
        return asn1
    }
}
