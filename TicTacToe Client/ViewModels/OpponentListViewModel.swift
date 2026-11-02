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
    
    var session: Session    
    var newPlayerFirstName = ""
    var newPlayerLastName = ""
    var newPlayerUserName = ""
    var newPlayerPassword = ""
    
    init(session: Session) {
        self.session = session
    }
    
    func fetchOpponents(playerID: UUID) async {
        do {
            session.opponents = try await Server.shared.fetchOpponents(playerID: playerID)
        } catch {
            print(error)
        }
    }
    
    func createPlayer(firstName: String, lastName: String, userName: String, password: String) async throws {
        let playerConfig = CreatePlayerDTO(firstName: firstName, lastName: lastName, userName: userName, password: password)
        
        do {
            let newPlayer: Player = try await Server.shared.createPlayer(config: playerConfig)
            session.opponents.append(newPlayer)
        } catch {
            print("Request failed")
        }
    }
}
