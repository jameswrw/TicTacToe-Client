//
//  Match.swift
//  TicTacToe Client
//
//  Converted to SwiftData @Model
//

import Foundation
import SwiftData

enum MatchInitError: Error {
    case missingPlayer
}


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
    
    init(from match: MatchDTO, usingContext context: ModelContext) throws {
        self.id = match.id

        let p1Fetch = FetchDescriptor<Player>(predicate: #Predicate { $0.id == match.player1 })
        let p2Fetch = FetchDescriptor<Player>(predicate: #Predicate { $0.id == match.player2 })

        guard
            let p1 = try context.fetch(p1Fetch).first,
            let p2 = try context.fetch(p2Fetch).first
        else {
            throw MatchInitError.missingPlayer
        }

        self.player1 = p1
        self.player2 = p2

        if let winnerID = match.winner {
            let winnerFetch = FetchDescriptor<Player>(predicate: #Predicate { $0.id == winnerID })
            self.winner = try context.fetch(winnerFetch).first
        } else {
            self.winner = nil
        }

        self.board = match.board
    }
}
