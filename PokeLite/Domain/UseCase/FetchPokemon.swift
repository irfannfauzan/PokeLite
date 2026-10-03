//
//  FetchPokemon.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

final class FetchPokemon {
    private let repository : PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Pokemon] {
        try await repository.fetchPokemon()
    }
    
}
