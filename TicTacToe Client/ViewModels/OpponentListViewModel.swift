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
    
    func fetchOpponents(playerID: UUID, context: ModelContext, server: ServerProtocol) async {
        do {
            let dto = try await server.fetchOpponents(playerID: playerID)
            session.opponents = dto.map { Player(from: $0) }
            
            for opponent in session.opponents {
                let targetID = opponent.id
                let fd = FetchDescriptor<Player>(predicate: #Predicate { $0.id == targetID })
                if let _ = try? context.fetch(fd).first {
                    // Optionally update fields if they changed
                    // existing?.firstName = opponent.firstName
                    // existing?.lastName = opponent.lastName
                } else {
                    context.insert(opponent)
                    try context.save()
                }
            }
        } catch {
            print(error)
        }
    }
    
    func createPlayer(
        firstName: String,
        lastName: String,
        userName: String,
        password: String,
        server: ServerProtocol,
        context: ModelContext
    ) async throws {
        let playerConfig = CreatePlayerDTO(firstName: firstName, lastName: lastName, userName: userName, password: password)
        
        do {
           let dto = try await server.createPlayer(config: playerConfig)
            let newPlayer = Player(from: dto)
            session.opponents.append(newPlayer)
            try context.save()
        } catch {
            print("Request failed")
        }
    }
}
