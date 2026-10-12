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
    var matchSelection : Match.ID? = nil

    init(session: Session) {
        self.session = session
    }
    
    func fetchMatches() async throws {
        matches = try await Server.shared.request(url: TicTacToeAPI.match.rawValue, method: .get)
    }
    
    func createMatch() async throws {
        
        guard let player1 = session.currentPlayer?.id,
              let player2 = session.opponent else {
            return
        }
        
        let coder = JSONEncoder()
        let matchDetails = MatchDetails(player1: player1, player2: player2)
        let matchData = try coder.encode(matchDetails)
        
        do {
            let newMatch: Match = try await Server.shared.request(
                url: TicTacToeAPI.createMatch.rawValue,
                body: matchData,
                method: .post
            )
            matches.append(newMatch)
        } catch {
            print("Request failed")
        }
    }

}
