//
//  PokemonRepositoriy.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//


import Foundation

final class PokemonRepositoriy: PokemonRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getPokemon() async throws -> [Pokemon] {
        let response: [PokemonDTO] = try await apiClient.get(.getPokemon)
        let products = response.map { $0.toDomain() }
        return products
    }
}
