//
//  CreatePlayerDTO.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 02/11/2026.
//

nonisolated struct CreatePlayerDTO: Encodable {
    let firstName: String
    let lastName: String
    let userName: String
    let password: String
}
