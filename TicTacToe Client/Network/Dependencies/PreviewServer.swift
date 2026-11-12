//
//  TestServer.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 09/11/2026.
//

import Dependencies
import Foundation

struct PreviewServer: ServerProtocol {
    var baseURL: URL = URL(string: "https://www.example.com")!
    var accessToken: String? = nil
    
    func login(credentials: Credentials) async throws -> LoginResponse {
        return .init(token: "12345", player: PlayerDTO.mock())
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
