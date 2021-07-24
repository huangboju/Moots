//
//  ContentView.swift
//  Landmarks
//
//  Created by 黄伯驹 on 2021/7/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
