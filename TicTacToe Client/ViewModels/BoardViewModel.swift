//
//  BoardViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 06/10/2026.
//

import Foundation

struct BoardViewModel {
    var board: String
    
    func playMove() {
        
    }
    
    func reset() {
        
    }
    
    func toggleTile() {
        
    }
    
    func tileValue(row: Int, col: Int) -> String {
        guard (0..<3).contains(row), (0..<3).contains(col) else {
            return "💀"
        }
        
        let rawBoard = Array(board)
        let tile = rawBoard[row * 3 + col]
        
        return switch tile {
        case "X": "❌"
        case "O": "⭕️"
        case ".": "·"
        default: "💀"
        }
    }
}
