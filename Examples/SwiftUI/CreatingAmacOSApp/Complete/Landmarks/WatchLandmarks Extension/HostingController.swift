/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A hosting controller for the watchOS app's root view.
*/

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView()
    }
}
