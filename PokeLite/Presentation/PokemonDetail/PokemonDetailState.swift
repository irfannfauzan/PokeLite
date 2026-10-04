//
//  PokemonDetailState.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import Foundation

enum PokemonDetailState {
    case loading
    case loaded(PokemonSpecies)
    case empty
    case error(String)
}

