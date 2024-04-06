//
//  AAAA.swift
//  Core Bluetooth HRM
//
//  Created by 黄伯驹 on 2024/4/6.
//  Copyright © 2024 Andrew Jaffee. All rights reserved.
//

import Foundation

public class GetRecordListHolder {
    public var itemIndex = 0
    public let totalNumber: Int
    public var fileId: Int
    public var numbersPerPack = 50
    var recordLists: [DeviceRecordListItem] = []
    
    public init(i2: Int) {
        totalNumber = i2
    }
    
    public var hasNext: Bool {
        return itemIndex < totalNumber
    }
    
    public var getNextItemBytes: [UInt8] {
        let i2 = itemIndex
        return [
            UInt8(i2 & 255),
            UInt8(min(totalNumber - i2 + 1, numbersPerPack) & 255)
        ]
    }

    public func parsingPacketToItem(_ bArr: [UInt8]) {
        let b2 = bArr[0]
        itemIndex += Int(b2)
        for i2 in 0..<b2 {
            var bArr2 = [UInt8](repeating: 0, count: 9)
            let begin = (i2 * 9) + 1
            for i in 0 ..< 9 {
                bArr2[i] = bArr[Int(begin) + i]
            }
            let b3 = bArr2[0]
            let bytesToLong = bytesToLong(bArr2, 1, 4)
            let item = DeviceRecordListItem(recordFileId: "\(b3)", recordSize: (bytesToLong + LibFitUtility.defSEC1989) * 1000, startTime: bytesToLong(bArr2, 5, 4))
            recordLists.append(item)
        }
    }
    
    func bytesToLong(_ bArr: [UInt8], _ i2: Int, _ i3: Int) -> Int {
        0
//        try {
//            byte[] bArr2 = new byte[i3];
//            System.arraycopy(bArr, i2, bArr2, 0, i3);
//            String str = TAG;
//            LogUtil.e(str, "bytesToLong :" + GibikeUtils.bytesToHex(bArr2));
//            return Long.parseLong(GibikeUtils.bytesToHex(bArr2), 16);
//        } catch (Exception e2) {
//            String str2 = TAG;
//            LogUtil.e(str2, "bytesToLong Exception:" + e2.getMessage());
//            return 0L;
//        }
    }
}
