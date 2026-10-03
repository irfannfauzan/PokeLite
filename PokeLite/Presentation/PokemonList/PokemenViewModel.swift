//
//  PokemonViewModel.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//


import Foundation

final class PokemonViewModel {
    
    private(set) var state: PokemonState = .loading {
        didSet { onStateChange?(state) }
    }
    
    var onStateChange: ((PokemonState) -> Void)?
    
    private let fetchPokemonUseCase: FetchPokemonUseCase
    private(set) var pokemon: [Pokemon] = []
    
    init(fetchPokemonUseCase: FetchPokemonUseCase) {
        self.fetchPokemonUseCase = fetchPokemonUseCase
    }
    
    @MainActor
    func loadPokemon() async {
        state = .loading
        do {
            let result = try await fetchPokemonUseCase.fetchPokemon()
            pokemon = result
            state = result.isEmpty ? .empty : .loaded(result)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
}
