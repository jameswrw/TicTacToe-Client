//
//  PlayerDTO.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 01/11/2026.
//

import Foundation

struct PlayerDTO: Codable {
    var id: UUID
    var firstName: String
    var lastName: String
}
