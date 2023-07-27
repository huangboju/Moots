/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A generic header view that has an NSTextField
*/

import Cocoa

class TitleSupplementaryView: NSView, NSCollectionViewElement {
    @IBOutlet weak var label: NSTextField!
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("title-supplementary-reuse-identifier")
}
