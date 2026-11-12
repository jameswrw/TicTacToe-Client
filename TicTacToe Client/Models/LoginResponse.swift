//
//  LoginResponse.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 12/11/2026.
//

import Foundation

nonisolated struct LoginResponse: Decodable {
    let token: String
    let player: PlayerDTO
}
