//
//  ViewController.swift
//  DragNDrop
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 Appcoda. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    
    @IBAction func showAvatars(_ sender: Any) {
        let storyboardName = NSStoryboard.Name(stringLiteral: "Main")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "avatarListStoryboardID")
        guard let avatarsWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController else { return }
        avatarsWindowController.showWindow(nil)
    }

}
