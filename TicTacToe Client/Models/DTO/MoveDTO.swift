//
//  MoveDTO.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 04/11/2026.
//

import Foundation

struct MoveDTO: Codable {
    let player: UUID
    let row: Int
    let col: Int
    let symbol: String
    
    init(player: Player, move: Move) {
        self.player = player.id
        self.row = move.row
        self.col = move.col
        self.symbol = switch move.symbol {
        case .cross:
            "X"
        case .nought:
            "O"
        default:
            "."
        }
    }
}
