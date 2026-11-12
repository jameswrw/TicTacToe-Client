//
//  Server.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation
import SwiftData
import Dependencies

enum RestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct Server: ServerProtocol, Observable {
    
    nonisolated(unsafe) var baseURL: URL
    let session: URLSession = .shared
    nonisolated(unsafe) var accessToken: String? = nil
    
    init(baseURL: URL, accessToken: String? = nil) {
        self.baseURL = baseURL
        self.accessToken = accessToken
    }
    
     private func request<T: Decodable>(
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
    func login(credentials: Credentials) async throws -> LoginResponse {
        let coder = JSONEncoder()
        let body = try coder.encode(credentials)
        return try await request(
            url: TicTacToeAPI.login,
            body: body,
            method: .post
        )
    }
    
    func createPlayer(config: CreatePlayerDTO) async throws -> PlayerDTO {
        let coder = JSONEncoder()
        let playerData = try coder.encode(config)
        return try await request(
            url: TicTacToeAPI.createPlayer,
            body: playerData,
            method: .post
        )
    }
    
    func playMove(
        match: Match,
        player: Player,
        move: Move
    ) async throws -> MatchDTO {
        let moveDTO = MoveDTO(player: player, move: move)
        let coder = JSONEncoder()
        let moveData = try coder.encode(moveDTO)
        
        return try await request(
            url: TicTacToeAPI.playMove,
            body: moveData,
            parameters: [.matchID: match.id.uuidString],
            method: .post
        )
    }
    
    func fetchOpponents(playerID: UUID) async throws -> [PlayerDTO] {
        try await request(
            url: TicTacToeAPI.oppenents,
            parameters: [.playerID: playerID.uuidString],
            method: .get
        )
    }
    
    func fetchMatches(player1: Player, player2: Player) async throws -> [MatchDTO] {
        try await request(
            url: TicTacToeAPI.fetchMatchWithPlayer,
            parameters: [.player1ID: player1.id.uuidString, .player2ID: player2.id.uuidString],
            method: .get
        )
    }
    
    func createMatch(player1: Player, player2: Player) async throws -> MatchDTO {
        let coder = JSONEncoder()
        let matchDetails = MatchDetailsDTO(player1: player1.id, player2: player2.id)
        let matchData = try coder.encode(matchDetails)
        
        return try await request(
            url: TicTacToeAPI.createMatch,
            body: matchData,
            method: .post
        )
    }
}

