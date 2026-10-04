//
//  Pokemon.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import Foundation

struct PokemonSpeciesColor: Equatable, Hashable {
    let name: String
}

struct PokemonSpecies: Equatable, Hashable {
    let name: String
    let color: PokemonSpeciesColor
}

struct Pokemon: Equatable, Hashable {
    let name: String
    let url: URL?
}
