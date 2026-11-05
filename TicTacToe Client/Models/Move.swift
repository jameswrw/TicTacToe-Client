//
//  Move.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 04/11/2026.
//

struct Move: Equatable, Codable {
    let row: Int
    let col: Int
    let symbol: BoardSymbol
}
