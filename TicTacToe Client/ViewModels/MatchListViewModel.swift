//
//  MatchListViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class MatchListViewModel {
    
    var session: Session
    var matches: [Match] = []

    // Bridge selection between Table's UUID? and the selected Match stored in Session
    var selectedMatchID: UUID? {
        get { session.match?.id }
        set {
            if let id = newValue {
                session.match = matches.first { $0.id == id }
            } else {
                session.match = nil
            }
        }
    }

    init(session: Session) {
        self.session = session
    }
    
    func fetchMatches(usingContext context: ModelContext, server: ServerProtocol) async throws {

        session.match = nil

        guard let player1 = session.currentPlayer, let player2 = session.opponent else {
            matches = []
            return
        }

        let dto = try await server.fetchMatches(player1: player1, player2: player2)
        matches = try dto.map { try Match(from: $0, usingContext: context) }
        try context.save()
    }
    
    func createMatch(withContext context: ModelContext, server: ServerProtocol) async throws -> Match? {
        
        guard let player1 = session.currentPlayer,
              let player2 = session.opponent else {
            return nil
        }
        
        let dto = try await server.createMatch(player1: player1, player2: player2)
        let newMatch = try Match(from: dto, usingContext: context)
        matches.append(newMatch)
        try context.save()
        return newMatch
    }

}
