//
//  Timeout.swift
//  SiriWave
//
//  Created by politom on 09/03/2019.
//

import Foundation

public class Timeout {
    
    public typealias ComplectionBlock = () -> Void
    
    public static func setInterval(_ interval: TimeInterval,
                                   block: @escaping ComplectionBlock) -> Timer {
        return Timer.scheduledTimer(timeInterval: interval,
                                    target: BlockOperation(block: block),
                                    selector: #selector(Operation.main),
                                    userInfo: nil, repeats: true)
    }
    
}
