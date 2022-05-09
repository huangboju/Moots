/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

// https://developer.apple.com/tutorials/app-dev-training/getting-started-with-scrumdinger

@main
struct ScrumdingerApp: App {
    @ObservedObject private var data = ScrumData()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $data.scrums) {
                    data.save()
                }
            }
            .onAppear {
                data.load()
            }
        }
    }
}
