//
//  ContentView.swift
//  Welcome
//
//  Created by Jordan Singer on 11/25/20.
//

import SwiftUI

struct ContentView: View {
    @State var showWelcomeScreen = true
    
    var body: some View {
        Button(action: { self.showWelcomeScreen = true }) {
            Text("Show Welcome screen")
        }
        .sheet(isPresented: $showWelcomeScreen) {
            WelcomeScreen(showWelcomeScreen: $showWelcomeScreen)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
