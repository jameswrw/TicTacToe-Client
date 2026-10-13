//
//  TicTacToeAPI.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import Foundation

enum URLParameters: String {
    case playerID = "{playerID}"
    case player1ID = "{player1ID}"
    case player2ID = "{player2ID}"
    case matchID = "{matchID}"
}

enum QueryParameters: String {
    case minTransactionTimestamp
    case maxTransactionTimestamp
}

enum TicTacToeAPI: String {
    case baseURL = "http://localhost:8080"
    case login = "/player/login"
    case player = "/player"
    case createPlayer = "/player/create"
    case oppenents = "/player/{playerID}/opponents"
    case match = "/match"
    case createMatch = "/match/create"
    case fetchMatch = "/match/{matchID}"
    case fetchMatchWithPlayer = "/match/featuring/{player1ID}/versus/{player2ID}"

}

