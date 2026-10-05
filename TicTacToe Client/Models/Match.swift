//
//  Match.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation

struct Match: Decodable, Identifiable {
    let id: UUID
    let player1: String
    let player2: String
    let winnner: String?
    let board: String
}
