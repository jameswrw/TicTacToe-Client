//
//  TicTacToeAPI.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation

enum URLParameters: String {
    case matchID = "{matchID}"
}

enum QueryParameters: String {
    case minTransactionTimestamp
    case maxTransactionTimestamp
}

enum TicTacToeAPI: String {
    case baseURL = "http://localhost:8080"
    case fetchPlayers = "/player"
    case match = "/match"
    case fetchMatch = "/match/{matchID}"
}

