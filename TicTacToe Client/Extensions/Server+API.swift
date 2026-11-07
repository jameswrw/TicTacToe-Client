//
//  Server+API.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 01/11/2026.
//

import Foundation
import SwiftData

//extension Server {
//    
//    func login(credentials: Credentials) async throws -> Player {
//        let coder = JSONEncoder()
//        let body = try coder.encode(credentials)
//        let playerDTO: PlayerDTO = try await request(
//            url: TicTacToeAPI.login,
//            body: body,
//            method: .post
//        )
//        return Player(from: playerDTO)
//    }
//    
//    func createPlayer(config: CreatePlayerDTO) async throws -> Player {
//        let coder = JSONEncoder()
//        let playerData = try coder.encode(config)
//        let newPlayer: PlayerDTO = try await request(
//            url: TicTacToeAPI.createPlayer,
//            body: playerData,
//            method: .post
//        )
//        return Player(from: newPlayer)
//    }
//    
//    func playMove(
//        match: Match,
//        player: Player,
//        move: Move,
//        context: ModelContext
//    ) async throws -> Match {
//        let moveDTO = MoveDTO(player: player, move: move)
//        let coder = JSONEncoder()
//        let moveData = try coder.encode(moveDTO)
//        
//        let matchDTO: MatchDTO = try await request(
//            url: TicTacToeAPI.playMove,
//            body: moveData,
//            parameters: [.matchID: match.id.uuidString],
//            method: .post
//        )
//        return try Match(from: matchDTO, usingContext: context)
//    }
//    
//    func fetchOpponents(playerID: UUID) async throws -> [Player] {
//        let opponents: [PlayerDTO] = try await request(
//            url: TicTacToeAPI.oppenents,
//            parameters: [.playerID: playerID.uuidString],
//            method: .get
//        )
//        return opponents.map { Player(from: $0) }
//    }
//    
//    func fetchMatches(player1: Player, player2: Player, context: ModelContext) async throws -> [Match] {        
//        let matches: [MatchDTO] = try await request(
//            url: TicTacToeAPI.fetchMatchWithPlayer,
//            parameters: [.player1ID: player1.id.uuidString, .player2ID: player2.id.uuidString],
//            method: .get
//        )
//        return try matches.map { try Match(from: $0, usingContext: context) }
//    }
//    
//    func createMatch(player1: Player, player2: Player, context: ModelContext) async throws -> Match {
//        let coder = JSONEncoder()
//        let matchDetails = MatchDetailsDTO(player1: player1.id, player2: player2.id)
//        let matchData = try coder.encode(matchDetails)
//        
//        let newMatch: MatchDTO = try await request(
//            url: TicTacToeAPI.createMatch,
//            body: matchData,
//            method: .post
//        )
//        return try Match(from: newMatch, usingContext: context)
//    }
//}
