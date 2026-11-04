//
//  BoardViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 06/10/2026.
//

import Foundation
import SwiftUI

enum BoardSymbol: String {
    case cross = "❌"
    case nought = "⭕️"
    case empty = "."
}

struct BoardViewModel {
    
    struct CandidateMove: Equatable {
        let row: Int
        let col: Int
        let symbol: BoardSymbol
    }
    
    var session: Session
    var board: String
    var candidateMove: CandidateMove?
    var currentMove: BoardSymbol = .cross
    
    init(session: Session, board: String) {
        self.session = session
        self.board = board
    }
    
    mutating func playMove() {
        guard candidateMove != nil else {
            return
        }
        
        if currentMove == .cross {
            currentMove = .nought
        } else if currentMove == .nought {
            currentMove = .cross
        }
    }
    
    mutating func toggleTile(row: Int, col: Int) {
        if let candidateMove,
           candidateMove.row == row && candidateMove.col == col {
            self.candidateMove = nil
        } else {
            if tileValue(row: row, col: col) == .empty {
                candidateMove = .init(row: row, col: col, symbol: currentMove)
            }
        }
    }
    
    func tileValue(row: Int, col: Int) -> BoardSymbol {
        guard (0..<3).contains(row), (0..<3).contains(col) else {
            return .empty
        }
        
        let index = board.index(board.startIndex, offsetBy: row * 3 + col)
        let moveAtIndex = board[index]
        
        return switch moveAtIndex {
        case "X": .cross
        case "O": .nought
        case ".": .empty
        default: .empty
        }
    }
    
    func isCandidateMove(row: Int, col: Int) -> Bool {
        guard let candidateMove = candidateMove else {
            return false
        }
        
        return candidateMove.row == row && candidateMove.col == col
    }
    
    func tileBackground(row: Int, col: Int) -> Color {
        isCandidateMove(row: row, col: col) ? .green.opacity(0.15) : Color(red: 0.8, green: 0.8, blue: 0.8)
    }
}
