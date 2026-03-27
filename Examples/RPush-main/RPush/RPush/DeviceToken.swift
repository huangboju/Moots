//
//  DeviceToken.swift
//  RPush
//
//  Created by Axe on 2021/1/11.
//

import Foundation

/// 格式化DeviceToken，8个字符一组分割。
/// - Parameter deviceToken: 源DeviceToken，如"dd09b5e36f1a1132c85541149635bc5d8e2241149e0a11584526e9a85b32f617"
/// - Returns: 格式化后的DeviceToken，如"dd09b5e3 6f1a1132 c8554114 9635bc5d 8e224114 9e0a1158 4526e9a8 5b32f617"
@discardableResult func formatDeviceToken(_ deviceToken: String) -> String {
    let text = deviceToken
    var output = text
    
    let insertCharacter: Character = " "
    if !text.isEmpty, !text.contains(insertCharacter) {
        var offset: Int = 0
        for idx in 0..<output.count {
            if idx != 0, idx % 8 == 0, idx + offset < output.count - 1 {
                let index = output.index(output.startIndex, offsetBy: offset + idx)
                output.insert(insertCharacter, at: index)
                offset += 1
            }
        }
    }
    
    return output
}

/// 将字符串的deviceToken转化为data
///
/// See: https://stackoverflow.com/questions/24394615/how-do-i-set-integer-endianness-using-htonl-in-swift/24653879#24653879
func convertDeviceToken(_ token: String) -> Data {
    var deviceTokenData = Data()
    var number: UInt32 = 0
    let scanner = Scanner(string: token)
    while !scanner.isAtEnd {
        scanner.scanHexInt32(&number)
        number = number.bigEndian
        withUnsafePointer(to: number) {
            let bytes = UnsafeRawPointer($0).assumingMemoryBound(to: UInt8.self)
            let count = MemoryLayout.size(ofValue: number)
            deviceTokenData.append(bytes, count: count)
        }
    }
    return deviceTokenData
}
