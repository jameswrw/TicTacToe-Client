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
    
    var matches: [Match] = []

    func fetchMatches() async throws {
        matches = try await Server.shared.request(url: TicTacToeAPI.match.rawValue, method: .get)
    }
}
