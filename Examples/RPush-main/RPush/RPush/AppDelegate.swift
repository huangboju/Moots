//
//  AppDelegate.swift
//  RPush
//
//  Created by Axe on 2021/1/5.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let window = NSApplication.shared.windows.first,
              let pushVC = window.contentViewController as? ViewController else { return }
        
        let splitVC = MainSplitViewController(pushViewController: pushVC)
        window.contentViewController = splitVC
        
        var frame = window.frame
        let newWidth: CGFloat = 960
        let newHeight: CGFloat = 700
        frame.origin.x -= (newWidth - frame.size.width) / 2
        frame.origin.y -= (newHeight - frame.size.height) / 2
        frame.size.width = newWidth
        frame.size.height = newHeight
        window.setFrame(frame, display: true)
        window.minSize = NSSize(width: 760, height: 550)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

}

