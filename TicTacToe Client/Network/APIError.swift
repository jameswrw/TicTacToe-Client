//
//  APIError.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case invalidURL
    case transportError(Error)
    case invalidResponse
    case httpError(Int, Data?)
    case decodingError(Error)

    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .transportError(let error):
            return "Transport error: \(error)"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let status, let data):
            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? "<no body>"
            return "HTTP error \(status): \(body)"
        case .decodingError(let error):
            return "Decoding error: \(error)"
        }
    }
}
