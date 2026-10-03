//
//  PokemonColor.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import UIKit

enum PokemonColor {
    static func uiColor(for name: String) -> UIColor {
        switch name.lowercased() {
        case "black": return .black
        case "blue": return .systemBlue
        case "brown": return .brown
        case "gray": return .systemGray
        case "green": return .systemGreen
        case "pink": return .systemPink
        case "purple": return .systemPurple
        case "red": return .systemRed
        case "white": return .white
        case "yellow": return .systemYellow
        default: return .systemGray
        }
    }
}
