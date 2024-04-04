//
//  PackageHead.swift
//  Core Bluetooth HRM
//
//  Created by 黄伯驹 on 2024/3/30.
//  Copyright © 2024 Andrew Jaffee. All rights reserved.
//

import Foundation

struct PackageHead {
    let headCode: UInt8
    let len: UInt8
    let paramCode: UInt8
    let setCode: UInt8
    
    init(data: Data) {
        let bytes = data.bytes
        headCode = bytes[0]
        len = bytes[1]
        setCode = bytes[2]
        paramCode = bytes[3]
    }
}

