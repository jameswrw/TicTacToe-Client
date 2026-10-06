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
        players = try await Server.shared.request(url: TicTacToeAPI.player.rawValue, method: .get)
    }
    
    func createPlayer(firstName: String, lastName: String) async throws {
        let coder = JSONEncoder()
        let player = CreatePlayer(firstName: firstName, lastName: lastName)
        let playerData = try coder.encode(player)
        
        do {
            let newPlayer: Player = try await Server.shared.request(
                url: TicTacToeAPI.createPlayer.rawValue,
                body: playerData,
                method: .post
            )
            players.append(newPlayer)
        } catch {
            print("Request failed")
        }
    }
}
