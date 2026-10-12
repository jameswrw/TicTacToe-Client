// Session.swift
// TicTacToe Client
//
// Provides global access to the currently logged-in player

import Foundation
import Observation

@Observable
final class Session {
    var currentPlayer: Player? = nil
    var opponents: [Player] = []
    var opponent: Player? = nil
}
