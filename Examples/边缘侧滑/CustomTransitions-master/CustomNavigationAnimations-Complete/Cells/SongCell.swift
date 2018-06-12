//
//  SongCell.swift
//  CustomNavigationAnimations-Starter
//
//  Created by Sam Stone on 29/09/2017.
//  Copyright © 2017 Sam Stone. All rights reserved.
//

import UIKit

class SongCell : UICollectionViewCell {
    
    @IBOutlet weak var songImage: UIImageView!

    public func refreshWith(song : Song){
        songImage.image = song.artwork
    }
    
}

