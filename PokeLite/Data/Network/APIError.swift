//
//  APIError.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//


import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case transport(Error)
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Url tidak valid!"
        case .transport:
            return "Tidak ada koneksi internet!"
        case .invalidResponse:
            return "Response server error!"
        case .httpStatus(let code):
            return "Server error!: \(code)"
        case .decoding(let error):
            return "Error decode data: \(error.localizedDescription)"
        }
    }
}


