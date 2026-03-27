//
//  LegacyNotificationFormat.swift
//  RPush
//
//  Created by Axe on 2021/1/11.
//

import Foundation

// The Payload maximum size.
// For regular remote notifications, the maximum size is 4KB (4096 bytes)
// For Voice over Internet Protocol (VoIP) notifications, the maximum size is 5KB (5120 bytes)
// NOTE: If you are using the legacy APNs binary interface to send notifications instead of an HTTP/2 request, the maximum payload size is 2KB (2048 bytes)
// Also see: https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CreatingtheNotificationPayload.html#//apple_ref/doc/uid/TP40008194-CH10-SW1
private let MAXPAYLOAD_SIZE: Int = 2048 // 2KB

private let DEVICE_BINARY_SIZE: UInt16 = 32

struct LegacyNotificationFormat: Formatter {
    
    let deviceToken: String
    let payload: String // JSON
    
    var formattedDeviceToken: String {
        return formatDeviceToken(deviceToken)
    }
    
    var data: Data {
        let deviceTokenData = convertDeviceToken(formattedDeviceToken)
        let deviceTokenBinary = deviceTokenData.withUnsafeBytes { [UInt8]($0) }
        let payloadBinary = payload.cString(using: .utf8)!
        let payloadLength = UInt16(strlen(payloadBinary))

        let bytes = [
            MemoryLayout<UInt8>.size,   // Command
            MemoryLayout<UInt16>.size,  // Token length (big endian)
            Int(DEVICE_BINARY_SIZE),    // deviceToken (binary)
            MemoryLayout<UInt16>.size,  // Payload length (big endian)
            MAXPAYLOAD_SIZE             // Payload (binary)
        ]
        
        let capacity = bytes.reduce(0, +) // 2085 bytes.
            
        var binaryMessageBuff = [CChar](repeating: 0, count: capacity)
        let bufferPointer = binaryMessageBuff.withUnsafeMutableBufferPointer { $0 }
        var binaryMessagePt = bufferPointer.baseAddress! // char *
                
        // message format is |COMMAND|TOKENLEN|TOKEN|PAYLOADLEN|PAYLOAD|
        // alse see: https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/LegacyNotificationFormat.html#//apple_ref/doc/uid/TP40008194-CH14-SW1

        var command: UInt8 = 0 // command number value of 0 (zero).
        var networkOrderTokenLength = DEVICE_BINARY_SIZE.bigEndian
        var networkOrderPayloadLength = payloadLength.bigEndian
        
        /* command */
        let commandBytes = MemoryLayout<UInt8>.size
        memcpy(binaryMessagePt, &command, commandBytes)
        binaryMessagePt += commandBytes
        
        /* token length network order */
        let networkOrderTokenLengthBytes = MemoryLayout<UInt16>.size
        memcpy(binaryMessagePt, &networkOrderTokenLength, networkOrderTokenLengthBytes)
        binaryMessagePt += networkOrderTokenLengthBytes
        
        /* device token */
        let deviceTokenBinaryBytes = Int(DEVICE_BINARY_SIZE)
        memcpy(binaryMessagePt, deviceTokenBinary, deviceTokenBinaryBytes)
        binaryMessagePt += deviceTokenBinaryBytes
        
        /* payload length network order */
        let networkOrderPayloadLengthBytes = MemoryLayout<UInt16>.size
        memcpy(binaryMessagePt, &networkOrderPayloadLength, networkOrderPayloadLengthBytes)
        binaryMessagePt += networkOrderPayloadLengthBytes
        
        /* payload */
        let payloadBinaryBytes = Int(payloadLength)
        memcpy(binaryMessagePt, payloadBinary, payloadBinaryBytes)
        binaryMessagePt += payloadBinaryBytes
        
        /* output data */
        let binaryMessageBuffer = binaryMessageBuff.withUnsafeMutableBufferPointer { $0 }.baseAddress!
        let count: Int = binaryMessagePt - binaryMessageBuffer
        let outputData = Data(bytes: binaryMessageBuff, count: count)
        
        return outputData
    }

}
