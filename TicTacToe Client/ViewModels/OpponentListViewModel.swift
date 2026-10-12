//
//  OpponentListViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class OpponentListViewModel {
    
    var opponents: [Player] = []
    var playerSelection : Player.ID? = nil
    
    var newPlayerFirstName = ""
    var newPlayerLastName = ""
    var newPlayerUserName = ""
    var newPlayerPassword = ""
    
    func fetchOpponents(playerID: UUID) async {
        do {
            opponents = try await Server.shared.request(
                url: TicTacToeAPI.oppenents.rawValue,
                parameters: [.playerID: playerID.uuidString],
                method: .get)
        } catch {
            print(error)
        }
    }
    
    func createPlayer(firstName: String, lastName: String, userName: String, password: String) async throws {
        let coder = JSONEncoder()
        let player = CreatePlayer(firstName: firstName, lastName: lastName, userName: userName, password: password)
        let playerData = try coder.encode(player)
        
        do {
            let newPlayer: Player = try await Server.shared.request(
                url: TicTacToeAPI.createPlayer.rawValue,
                body: playerData,
                method: .post
            )
            opponents.append(newPlayer)
        } catch {
            print("Request failed")
        }
    }
}
