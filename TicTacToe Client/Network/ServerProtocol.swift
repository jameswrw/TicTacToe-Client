//
//  ServerProtocol.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 07/11/2026.
//

import Foundation
import SwiftData

protocol ServerProtocol {
    func request<T: Decodable>(
        url path: TicTacToeAPI,
        body: Data?,
        parameters: [URLParameters: String],
        queryItems: [URLQueryItem]?,
        method: RestMethod
    ) async throws -> T
    
    func login(credentials: Credentials) async throws-> Player
    func createPlayer(config: CreatePlayerDTO) async throws -> Player
    
    func playMove(
        match: Match,
        player: Player,
        move: Move,
        context: ModelContext
    ) async throws -> Match
    
    func fetchOpponents(playerID: UUID) async throws -> [Player]
    func fetchMatches(player1: Player, player2: Player, context: ModelContext) async throws -> [Match]
    func createMatch(player1: Player, player2: Player, context: ModelContext) async throws -> Match
    
    
}
