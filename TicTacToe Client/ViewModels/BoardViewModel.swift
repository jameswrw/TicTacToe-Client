//
//  BoardViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 06/10/2026.
//

import Foundation
import SwiftUI
import SwiftData

//enum BoardSymbol: String, Codable {
//    case cross = "❌"
//    case nought = "⭕️"
//    case empty = "."
//}

enum BoardSymbol: String, Codable {
    case cross = "X"
    case nought = "O"
    case empty = "."
}

@Observable
class BoardViewModel {
    
    var session: Session
    var board: String {
        session.match?.board ?? "........."
    }
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
    
    init(session: Session) {
        self.session = session
    }
    
    func playMove(context: ModelContext, server: ServerProtocol) async throws {
        guard let candidateMove,
              var match = session.match,
              let currentPlayer = session.currentPlayer
        else {
            return
        }
        
        match = try await server.playMove(
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
    
    func toggleTile(row: Int, col: Int) {
        if let candidateMove,
           candidateMove.row == row && candidateMove.col == col {
            self.candidateMove = nil
        } else {
            if tileValue(row: row, col: col) == BoardSymbol.empty.rawValue {
                candidateMove = .init(row: row, col: col, symbol: currentMove)
            }
        }
    }
    
    func tileValue(row: Int, col: Int) -> String {
        guard (0..<3).contains(row), (0..<3).contains(col) else {
            return BoardSymbol.empty.rawValue
        }
        
        let symbol: BoardSymbol
        if isCandidateMove(row: row, col: col) {
            symbol = candidateMove?.symbol ?? BoardSymbol.empty
        } else {
            let index = board.index(board.startIndex, offsetBy: row * 3 + col)
            symbol = BoardSymbol(rawValue: String(board[index])) ?? .empty
        }
        
        return switch symbol {
        case .cross: "❌"
        case .nought: "⭕️"
        default: "."
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
    
    func moveText() -> String {
        guard let match = session.match else {
            return "Error"
        }
        
        if match.winner != nil {
            return winText(match: match)
        } else {
            return playerMoveText(match: match)
        }
    }
    
    private func winText(match: Match) -> String {
        guard let winner = match.winner else {
            return "Error"
        }
        
        return winner == session.currentPlayer ? "You won" : "They won"
    }
    
    private func playerMoveText(match: Match) -> String {
        
        let isPlayerOne = match.player1 == session.currentPlayer
        
        let xs = match.board
            .filter { String($0) == BoardSymbol.cross.rawValue }
            .count
        let os = match.board
            .filter { String($0) == BoardSymbol.nought.rawValue }
            .count
        
        var isPlayerMove = false
        if (isPlayerOne && (xs < os)) || (!isPlayerOne && (xs == os)) {
            isPlayerMove = true
        }
        return isPlayerMove ? "Your move" : "Their move"
    }
}
