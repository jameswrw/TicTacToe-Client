//
//  MatchDetailsDTO.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 01/11/2026.
//

import Foundation

nonisolated struct MatchDetailsDTO: Encodable {
    let player1: UUID
    let player2: UUID
}
