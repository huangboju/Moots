//
//  RoomDetail.swift
//  Rooms
//
//  Created by jourhuang on 2020/10/17.
//

import SwiftUI

struct RoomDetail: View {
    let room: Room
    var body: some View {
        Text(room.name)
            .font(.title)
            .navigationBarTitle(Text(room.name), displayMode: .inline)
    }
}

struct RoomDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { RoomDetail(room: testData[0]) }
    }
}
