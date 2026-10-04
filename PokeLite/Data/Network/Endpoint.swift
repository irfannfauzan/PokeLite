//
//  Endpoint.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//


import Foundation

enum Endpoint {
    case fetchPokemon
    case fetchDetailPokemon(id: Int)
    
    private static let baseURL = "https://pokeapi.co/api/v2"
    
    func url() -> URL? {
        switch self {
            
        case.fetchPokemon:
            let components = URLComponents(string: "\(Self.baseURL)/pokemon")
            return components?.url
            
        case.fetchDetailPokemon(let id):
            return URL(string: "\(Self.baseURL)/pokemon-species/\(id)")
        }
    }
}
