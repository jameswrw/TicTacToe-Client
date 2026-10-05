//
//  Server.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation

enum RestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct Server {
    let baseURL: URL
    let session: URLSession
    var accessToken: String? = nil
    
    private static var _shared: Server = Server()
    static var shared: Server { _shared }

    static func configure(baseURL: URL, session: URLSession = .shared) {
        _shared = Server(baseURL: baseURL, session: session)
    }
    
    static func setAccessToken(_ token: String?) async {
        _shared.accessToken = token
    }

    init(
        // baseURL should be set to something sensible in appDelegate didFinishLaunchingWithOptions.
        baseURL: URL = URL(string: TicTacToeAPI.baseURL.rawValue)!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func request<T: Decodable>(
        url path: String,
        body: Data? = nil,
        parameters: [URLParameters: String] = [:],
        queryItems: [URLQueryItem]? = nil,
        method: RestMethod
    ) async throws -> T {
        let request = try makeRequest(path: path, body: body, urlParameters: parameters, queryItems: queryItems, method: method)
        
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
