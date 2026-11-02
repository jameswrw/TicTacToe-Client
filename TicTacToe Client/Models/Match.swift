//
//  Match.swift
//  TicTacToe Client
//
//  Converted to SwiftData @Model
//

import Foundation
import SwiftData

@Model
final class Match: Identifiable {
    @Attribute(.unique) var id: UUID
    var player1: Player
    var player2: Player
    var winner: Player?
    var board: String

    init(id: UUID = UUID(), player1: Player, player2: Player, winner: Player? = nil, board: String) {
        self.id = id
        self.player1 = player1
        self.player2 = player2
        self.winner = winner
        self.board = board
    }
    
    init(from match: MatchDTO) {
        self.id = match.id
        self.player1 = Player(from: match.player1)
        self.player2 = Player(from: match.player2)
        
        if let winner = match.winner {
            self.winner = Player(from: winner)
        } else {
            self.winner = nil
        }

        self.board = match.board
    }
}
