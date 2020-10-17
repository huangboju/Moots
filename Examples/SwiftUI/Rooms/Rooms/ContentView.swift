//
//  ContentView.swift
//  Rooms
//
//  Created by jourhuang on 2020/10/17.
//

import SwiftUI

struct ContentView: View {
    var rooms: [Room] = []

    var body: some View {
        NavigationView {
            List(rooms) { room in
                RoomCell(room: room)
            }
            .navigationBarTitle(Text("Rooms"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(rooms: testData)
        }
    }
}

struct RoomCell: View {
    let room: Room
    var body: some View {
        NavigationLink(destination: RoomDetail(room: room)) {
            HStack {
                Image(systemName: "photo")
                Text(room.name)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }
}
