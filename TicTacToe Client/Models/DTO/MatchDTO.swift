//
//  MatchDTO.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 01/11/2026.
//

import Foundation

nonisolated struct MatchDTO: Codable {
    let id: UUID
    let player1: UUID
    let player2: UUID
    let winner: UUID?
    let board: String
    
    static func mock() -> Self {
        return .init(id: UUID(), player1: UUID(), player2: UUID(), winner: nil, board: ".........")
    }
}
