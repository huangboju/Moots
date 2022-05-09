//
//  AbilitiesViewModel.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/09.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct AbilityViewModel: Identifiable, Codable {

    let ability: Ability

    init(ability: Ability) {
        self.ability = ability
    }

    var id: Int { ability.id }
    var name: String { ability.names.CN }
    var nameEN: String { ability.names.EN }
    var descriptionText: String { ability.flavorTextEntries.CN.newlineRemoved }
    var descriptionTextEN: String { ability.flavorTextEntries.EN.newlineRemoved }
}

extension AbilityViewModel: CustomStringConvertible {
    var description: String {
        "AbilityViewModel - \(id) - \(self.name)"
    }
}
