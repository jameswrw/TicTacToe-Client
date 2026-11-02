//
//  MatchListViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MatchListViewModel {
    
    var session: Session
    var matches: [Match] = []

    init(session: Session) {
        self.session = session
    }
    
    func fetchMatches() async throws {

        session.match = nil

        guard let player1 = session.currentPlayer, let player2 = session.opponent else {
            matches = []
            return
        }

        matches = try await Server.shared.fetchMatches(player1: player1, player2: player2)
    }
    
    func createMatch() async throws {
        
        guard let player1 = session.currentPlayer,
              let player2 = session.opponent else {
            return
        }
        
        let newMatch = try await Server.shared.createMatch(player1: player1, player2: player2)
        matches.append(newMatch)
    }

}
