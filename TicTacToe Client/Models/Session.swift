// Session.swift
// TicTacToe Client
//
// Provides global access to the currently logged-in player

import Foundation

@Observable
final nonisolated class Session {
    // Current logged-in player
    var currentPlayer: Player?

    // Potential opponents list
    var opponents: [Player]

    // Selected opponent and match identifiers
    var opponent: Player?
    var match: Match?

    init(currentPlayer: Player? = nil, opponents: [Player] = [], opponent: Player? = nil, match: Match? = nil) {
        self.currentPlayer = currentPlayer
        self.opponents = opponents
        self.opponent = opponent
        self.match = match
    }
}
