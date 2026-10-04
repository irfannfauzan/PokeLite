//
//  FetchPokemonDetail.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

final class FetchPokemonDetailUseCase {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonSpecies {
        try await repository.fetchPokemonDetail(id: id)
    }
    
}
