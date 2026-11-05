//
//  BoardViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 06/10/2026.
//

import Foundation
import SwiftUI
import SwiftData

enum BoardSymbol: String, Codable {
    case cross = "❌"
    case nought = "⭕️"
    case empty = "."
}

struct BoardViewModel {
    
    var session: Session
    var board: String
    var candidateMove: Move?
    var currentMove: BoardSymbol {
        let xs = board
            .filter { $0 == "X" }
            .count
        let os = board
            .filter { $0 == "O" }
            .count
        return xs <= os ? .cross : .nought
    }
    
    init(session: Session, board: String) {
        self.session = session
        self.board = board
    }
    
    func playMove(context: ModelContext) async throws {
        guard let candidateMove,
              var match = session.match,
              let currentPlayer = session.currentPlayer
        else {
            return
        }
        
        match = try await Server.shared.playMove(
            match: match,
            player: currentPlayer,
            move: candidateMove,
            context: context
        )
        
        // Before try context.save()
        let fetch = FetchDescriptor<Player>()
        if let players = try? context.fetch(fetch) {
            for p in players {
                print("Player in context:", p.id, p.firstName, p.lastName)
            }
        }
        
        session.match = match
        try context.save()
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
