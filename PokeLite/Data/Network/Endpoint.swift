//
//  Endpoint.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//


import Foundation

enum Endpoint {
    case fetchPokemon
    
    private static let baseURL = "https://pokeapi.co/api/v2/pokemon"
    
    func url() -> URL? {
        switch self {
            
        case.fetchPokemon:
            let components = URLComponents(string: Self.baseURL)
            return components?.url
            
        }
    }
}
