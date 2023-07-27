/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Item for displaying a Wi-Fi network name
*/

import Cocoa

class WiFiNetworkItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("wifi-network-item-reuse-identifier")

    @IBOutlet weak var checkBox: NSButton!
}
