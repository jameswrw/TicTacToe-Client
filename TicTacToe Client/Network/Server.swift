//
//  Server.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation
import SwiftData

enum RestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

@MainActor
class Server: ServerProtocol, Observable {
    var baseURL: URL
    let session: URLSession = .shared
    var accessToken: String? = nil
    
    init(baseURL: URL, accessToken: String? = nil) {
        self.baseURL = baseURL
        self.accessToken = accessToken
    }
    
     func request<T: Decodable>(
        url path: TicTacToeAPI,
        body: Data? = nil,
        parameters: [URLParameters: String] = [:],
        queryItems: [URLQueryItem]? = nil,
        method: RestMethod
    ) async throws -> T {
        let request = try makeRequest(
            path: path.rawValue,
            body: body,
            urlParameters: parameters,
            queryItems: queryItems,
            method: method
        )
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(http.statusCode) else {
                throw APIError.httpError(http.statusCode, data)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as APIError {
            throw error
        } catch {
            // Distinguish transport vs decoding when possible
            if (error as? URLError) != nil {
                throw APIError.transportError(error)
            } else if (error as? DecodingError) != nil {
                throw APIError.decodingError(error)
            } else {
                throw error
            }
        }
    }
    
    private func makeRequest(
        path: String,
        body: Data? = nil,
        urlParameters: [URLParameters: String],
        queryItems: [URLQueryItem]? = nil,
        method: RestMethod
    ) throws -> URLRequest {
        
        var mutablePath = path
        for key in urlParameters.keys {
            mutablePath = mutablePath.replacingOccurrences(of: key.rawValue, with: urlParameters[key]!)
        }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        // Ensure we don’t lose any existing path on baseURL
        let existingPath = components?.path ?? ""
        let normalizedExisting = existingPath.hasSuffix("/") ? String(existingPath.dropLast()) : existingPath
        let normalizedPath = mutablePath.hasPrefix("/") ? String(mutablePath.dropFirst()) : mutablePath
        components?.path = normalizedExisting.isEmpty ? "/\(normalizedPath)" : "\(normalizedExisting)/\(normalizedPath)"
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        let token = accessToken ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
 
extension Server {
    func login(credentials: Credentials) async throws -> Player {
        let coder = JSONEncoder()
        let body = try coder.encode(credentials)
        let playerDTO: PlayerDTO = try await request(
            url: TicTacToeAPI.login,
            body: body,
            method: .post
        )
        return Player(from: playerDTO)
    }
    
    func createPlayer(config: CreatePlayerDTO) async throws -> Player {
        let coder = JSONEncoder()
        let playerData = try coder.encode(config)
        let newPlayer: PlayerDTO = try await request(
            url: TicTacToeAPI.createPlayer,
            body: playerData,
            method: .post
        )
        return Player(from: newPlayer)
    }
    
    func playMove(
        match: Match,
        player: Player,
        move: Move,
        context: ModelContext
    ) async throws -> Match {
        let moveDTO = MoveDTO(player: player, move: move)
        let coder = JSONEncoder()
        let moveData = try coder.encode(moveDTO)
        
        let matchDTO: MatchDTO = try await request(
            url: TicTacToeAPI.playMove,
            body: moveData,
            parameters: [.matchID: match.id.uuidString],
            method: .post
        )
        return try Match(from: matchDTO, usingContext: context)
    }
    
    func fetchOpponents(playerID: UUID) async throws -> [Player] {
        let opponents: [PlayerDTO] = try await request(
            url: TicTacToeAPI.oppenents,
            parameters: [.playerID: playerID.uuidString],
            method: .get
        )
        return opponents.map { Player(from: $0) }
    }
    
    func fetchMatches(player1: Player, player2: Player, context: ModelContext) async throws -> [Match] {
        let matches: [MatchDTO] = try await request(
            url: TicTacToeAPI.fetchMatchWithPlayer,
            parameters: [.player1ID: player1.id.uuidString, .player2ID: player2.id.uuidString],
            method: .get
        )
        return try matches.map { try Match(from: $0, usingContext: context) }
    }
    
    func createMatch(player1: Player, player2: Player, context: ModelContext) async throws -> Match {
        let coder = JSONEncoder()
        let matchDetails = MatchDetailsDTO(player1: player1.id, player2: player2.id)
        let matchData = try coder.encode(matchDetails)
        
        let newMatch: MatchDTO = try await request(
            url: TicTacToeAPI.createMatch,
            body: matchData,
            method: .post
        )
        return try Match(from: newMatch, usingContext: context)
    }
}

