//
//  PokemonDetailViewModel.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import Foundation

final class PokemonDetailViewModel {
    private(set) var state: PokemonDetailState = .loading {
        didSet { onStateChange?(state) }
    }
    
    var onStateChange: ((PokemonDetailState) -> Void)?
    
    private let fetchPokemonDetailUseCase: FetchPokemonDetailUseCase
    let pokemonId: Int
    
    init(fetchPokemonDetailUseCase: FetchPokemonDetailUseCase, pokemonId: Int) {
        self.fetchPokemonDetailUseCase = fetchPokemonDetailUseCase
        self.pokemonId = pokemonId
    }
    
    @MainActor
    func loadDetail() async {
        state = .loading
        do {
            let result = try await fetchPokemonDetailUseCase.fetchPokemonDetail(id: pokemonId)
            state = .loaded(result)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
