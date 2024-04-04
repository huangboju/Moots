//
//  GibikeUtils.swift
//  Core Bluetooth HRM
//
//  Created by 黄伯驹 on 2024/3/30.
//  Copyright © 2024 Andrew Jaffee. All rights reserved.
//

import Foundation

class GibikeUtils {
    public static func bytesToHexString(_ data: Data) -> String {
        data.hexEncodedString()
    }
    
    public static func binaryString2byte(_ str: String) -> UInt8 {
        var result: UInt8 = 0
        for char in str {
            result = result * 2 % 255
            result += UInt8(Int(String(char)) ?? 0)
        }
        return result
    }
}

extension Int {
    var binaryString: String {
        String(self, radix: 2)
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
    
    var composeByteWithCommand: Data {
        let bytes = self.bytes
        var result = [UInt8](repeating: 0, count: bytes.count + 2)
        result[0] = 60
        result[1] = UInt8(bytes.count)
        for (i, byte) in bytes.enumerated() {
            result[i + 2] = byte
        }
        return Data(result)
    }
}
