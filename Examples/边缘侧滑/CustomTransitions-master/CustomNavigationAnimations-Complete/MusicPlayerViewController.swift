//
//  MusicPlayerViewController.swift
//  CustomNavigationAnimations-Starter
//
//  Created by Sam Stone on 29/09/2017.
//  Copyright © 2017 Sam Stone. All rights reserved.
//

import UIKit

class MusicPlayerViewController : UIViewController {
    
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artist: UILabel!

    public var song : Song?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let song = self.song {
            artwork.image = song.artwork
            songTitle.text = song.title
            artist.text = song.artist
        }
    }
    
}
