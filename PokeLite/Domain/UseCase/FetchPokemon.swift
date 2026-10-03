//
//  FetchPokemon.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

final class FetchPokemonUseCase {
    private let repository : PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchPokemon() async throws -> [Pokemon] {
        try await repository.fetchPokemon()
    }
    
}
