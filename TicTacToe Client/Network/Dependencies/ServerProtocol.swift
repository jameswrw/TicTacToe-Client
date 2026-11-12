//
//  ServerProtocol.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 07/11/2026.
//

import Foundation
import Dependencies

nonisolated protocol ServerProtocol: Sendable {
//    func request<T: Decodable>(
//        url path: TicTacToeAPI,
//        body: Data?,
//        parameters: [URLParameters: String],
//        queryItems: [URLQueryItem]?,
//        method: RestMethod
//    ) async throws -> T
    
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
