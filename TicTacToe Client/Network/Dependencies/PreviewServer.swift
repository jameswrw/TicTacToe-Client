//
//  TestServer.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 09/11/2026.
//

import Dependencies
import Foundation

struct PreviewServer: ServerProtocol {
    func login(credentials: Credentials) async throws -> PlayerDTO {
        return PlayerDTO.mock()
    }
    
    func createPlayer(config: CreatePlayerDTO) async throws -> PlayerDTO {
        return PlayerDTO.mock()
    }
    
    func playMove(match: Match, player: Player, move: Move) async throws -> MatchDTO {
        return MatchDTO.mock()
    }
    
    func fetchOpponents(playerID: UUID) async throws -> [PlayerDTO] {
        return [PlayerDTO.mock()]
    }
    
    func fetchMatches(player1: Player, player2: Player) async throws -> [MatchDTO] {
        return [MatchDTO.mock()]
    }
    
    func createMatch(player1: Player, player2: Player) async throws -> MatchDTO {
        return MatchDTO.mock()
    }
}
