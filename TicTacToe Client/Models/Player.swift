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

struct CreatePlayer: Encodable {
    let firstName: String
    let lastName: String
    let userName: String
    let password: String
}
