//
//  PokemonRepository.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import Foundation

final class PokemonRepository: PokemonRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchPokemon() async throws -> [Pokemon] {
        let response: PokemonListResponseDTO = try await apiClient.get(.fetchPokemon)
        let pokemon = response.results.map { $0.toDomain() }
        return pokemon
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonSpecies {
        let response: PokemonSpeciesDTO = try await apiClient.get(.fetchDetailPokemon(id: id))
        let pokemon = response.toDomain()
        return pokemon
    }
}

