//
//  User.swift
//  PokeMaster
//
//  Created by 黄伯驹 on 2022/1/23.
//

import SwiftUI

struct User: Codable {
    var email: String
    
    var favoritePokemonIDs: Set<Int>
    
    func isFacoritePokemon(id: Int) -> Bool {
        favoritePokemonIDs.contains(id)
    }
}
