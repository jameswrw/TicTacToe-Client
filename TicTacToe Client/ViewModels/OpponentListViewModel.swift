//
//  OpponentListViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation
import Observation
import SwiftData

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
    
    func fetchOpponents(playerID: UUID, context: ModelContext) async {
        do {
            session.opponents = try await Server.shared.fetchOpponents(playerID: playerID)
            
            for opponent in session.opponents {
                let targetID = opponent.id
                let fd = FetchDescriptor<Player>(predicate: #Predicate { $0.id == targetID })
                if let _ = try? context.fetch(fd).first {
                    // Optionally update fields if they changed
                    // existing?.firstName = opponent.firstName
                    // existing?.lastName = opponent.lastName
                } else {
                    context.insert(opponent)
                }
            }
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
