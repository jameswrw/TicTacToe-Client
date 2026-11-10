//
//  TestServer.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 09/11/2026.
//

import Dependencies
import Foundation

nonisolated final class TestServer: ServerProtocol {
    func login(credentials: Credentials) async throws -> PlayerDTO {
        reportIssue("TestServer.login() unimplemented")
        return PlayerDTO.mock()
    }
    
    func createPlayer(config: CreatePlayerDTO) async throws -> PlayerDTO {
        reportIssue("TestServer.createPlayer() unimplemented")
        return PlayerDTO.mock()
    }
    
    func playMove(match: Match, player: Player, move: Move) async throws -> MatchDTO {
        reportIssue("TestServer.playMove() unimplemented")
        return MatchDTO.mock()
    }
    
    func fetchOpponents(playerID: UUID) async throws -> [PlayerDTO] {
        reportIssue("TestServer.fetchOpponents() unimplemented")
        return [PlayerDTO.mock()]
    }
    
    func fetchMatches(player1: Player, player2: Player) async throws -> [MatchDTO] {
        reportIssue("TestServer.fetchMatches() unimplemented")
        return [MatchDTO.mock()]
    }
    
    func createMatch(player1: Player, player2: Player) async throws -> MatchDTO {
        reportIssue("TestServer.createMatch() unimplemented")
        return MatchDTO.mock()
    }
    
    
}
