//
//  Sample.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/08/28.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

#if DEBUG

extension Pokemon {
    static func sample(id: Int) -> Pokemon {
        return FileHelper.loadBundledJSON(file: "pokemon-\(id)")
    }
}

extension PokemonSpecies {
    static func sample(url: URL) -> PokemonSpecies {
        return FileHelper.loadBundledJSON(file: "pokemon-species-\(url.extractedID!)")
    }
}

extension Ability {
    static func sample(url: URL) -> Ability {
        sample(id: url.extractedID!)
    }

    static func sample(id: Int) -> Ability {
        return FileHelper.loadBundledJSON(file: "ability-\(id)")
    }
}

extension PokemonViewModel {
    static var all: [PokemonViewModel] = {
        (1...30).map { id in
            let pokemon = Pokemon.sample(id: id)
            let species = PokemonSpecies.sample(url: pokemon.species.url)
            return PokemonViewModel(pokemon: pokemon, species: species)
        }
    }()

    static let samples: [PokemonViewModel] = [
        sample(id: 1),
        sample(id: 2),
        sample(id: 3),
    ]

    static func sample(id: Int) -> PokemonViewModel {
        let pokemon = Pokemon.sample(id: id)
        let species = PokemonSpecies.sample(url: pokemon.species.url)
        return PokemonViewModel(pokemon: pokemon, species: species)
    }
}

extension AbilityViewModel {
    static func sample(pokemonID: Int) -> [AbilityViewModel] {
        Pokemon.sample(id: pokemonID).abilities.map {
            AbilityViewModel(ability: Ability.sample(url: $0.ability.url))
        }
    }
}
#endif
