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
    case baseURL = "http://proxyman.debug:8080"
    case login = "/player/login"
    case createPlayer = "/player/create"
    case oppenents = "/player/{playerID}/opponents"
    case createMatch = "/match/create"
    case playMove = "/match/{matchID}/play"
    case fetchMatchWithPlayer = "/match/featuring/{player1ID}/versus/{player2ID}"

}

