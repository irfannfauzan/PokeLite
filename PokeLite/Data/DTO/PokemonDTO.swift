//
//  PokemonDTO.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import Foundation

struct PokemonDTO: Codable {
    let name: String
    let url: String?
}

extension PokemonDTO {
    func toDomain() -> Pokemon {
        Pokemon(name: name, url: url.flatMap(URL.init(string:)))
    }
}

struct PokemonListResponseDTO: Codable {
    let results: [PokemonDTO]
    let count: Int
}
