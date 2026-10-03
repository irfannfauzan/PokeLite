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
    
    init(pokemonId: Int, fetchPokemonDetailUseCase: FetchPokemonDetailUseCase) {
        self.pokemonId = pokemonId
        self.fetchPokemonDetailUseCase = fetchPokemonDetailUseCase
    }
    
    @MainActor
    func loadDetail() async {
        state = .loading
        do {
            let product = try await fetchPokemonDetailUseCase.fetchPokemonDetail(id: pokemonId)
            state = .loaded(product)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

