//
//  PokemonRepositoryProtocol.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import Foundation

protocol PokemonRepositoryProtocol {
    func fetchPokemon() async throws -> [Pokemon]
    func fetchPokemonDetail(id: Int) async throws -> Pokemon
}
