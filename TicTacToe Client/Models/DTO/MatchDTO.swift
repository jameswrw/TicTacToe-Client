//
//  MatchDTO.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 01/11/2026.
//

import Foundation

struct MatchDTO: Codable {
    let id: UUID
    let player1: PlayerDTO
    let player2: PlayerDTO
    let winner: PlayerDTO?
    let board: String
}
