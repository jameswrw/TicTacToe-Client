//
//  PlayerListViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class PlayerListViewModel {
    
    var players: [Player] = []
    var playerSelection : Player.ID? = nil
    
    func fetchPlayers() async throws {
        players = try await Server.shared.request(url: TicTacToeAPI.fetchPlayers.rawValue, method: .get)
    }
}
