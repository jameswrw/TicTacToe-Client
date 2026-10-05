//
//  Player.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation

struct Player: Decodable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
}
