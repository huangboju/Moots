//
//  BackgroundMusicPlayer.swift
//  ZombieConga
//
//  Created by 黄伯驹 on 2019/3/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import AVFoundation

class BackgroundMusicPlayer: AVAudioPlayer {
    enum BMPError: Error {
        case fileNotFound
    }
    
    convenience init(filename: Strings) throws {
        guard let url = Bundle.main.url(forResource: filename.rawValue, withExtension: nil) else { throw BMPError.fileNotFound }
        
        try self.init(contentsOf: url)
        numberOfLoops = -1
        prepareToPlay()
    }
}
