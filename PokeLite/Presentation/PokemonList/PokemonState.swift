//
//  PokemonState.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//


enum PokemonState {
    case loading
    case loaded([Pokemon])
    case empty
    case error(String)
}
