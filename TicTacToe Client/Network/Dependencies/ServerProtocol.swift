//
//  ServerProtocol.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 07/11/2026.
//

import Foundation
import Dependencies

nonisolated protocol ServerProtocol: Sendable {
    
    var baseURL: URL {get set}
    var accessToken: String? {get set}

    func login(credentials: Credentials) async throws -> LoginResponse
    func createPlayer(config: CreatePlayerDTO) async throws -> PlayerDTO
    
    func playMove(
        match: Match,
        player: Player,
        move: Move,
    ) async throws -> MatchDTO
    
    func fetchOpponents(playerID: UUID) async throws -> [PlayerDTO]
    func fetchMatches(player1: Player, player2: Player) async throws -> [MatchDTO]
    func createMatch(player1: Player, player2: Player) async throws -> MatchDTO
}
