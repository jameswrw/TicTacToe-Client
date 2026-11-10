//
//  BoardView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 06/10/2026.
//

import SwiftUI
import SwiftData
import Dependencies

struct BoardView: View {
    @Bindable var viewModel: BoardViewModel
    @Environment(\.modelContext) private var context
    @Dependency(\.server) private var server
    
    var body: some View {
        Text("Match")
            .font(.largeTitle)
        Text(viewModel.moveText())
        
        grid()

        HStack {
            Button {
                Task {
                    do {
                        try await viewModel.playMove(context: context, server: server)
                    } catch {
                        print("Failed to play move")
                    }
                }
            } label: {
                Text("Play move")
            }
            .disabled(viewModel.candidateMove == nil)
        }
        .padding()
        .onChange(of: viewModel.session.opponent) { _, _ in
            if viewModel.session.opponent == nil {
                viewModel.session.match = nil
            }
        }
    }
    
    func grid() -> some View {
        VStack {
            row(0)
            row(1)
            row(2)
        }
        .padding()
    }
    
    func row(_ row: Int) -> some View {
        HStack {
            tile(row: row, col: 0)
            tile(row: row, col: 1)
            tile(row: row, col: 2)
        }
    }
    
    func tile(row: Int, col: Int) -> some View {
        Button {
            viewModel.toggleTile(row: row, col: col)
        } label: {
            let symbol = viewModel.tileValue(row: row, col: col)
            return Text(symbol)
                .font(.largeTitle)
                .frame(width: 50, height: 50)
        }
        .background(viewModel.tileBackground(row: row, col: col))
        .disabled(viewModel.session.match?.winner != nil)
    }
}

#Preview {
    @Dependency(\.server) var server

    let player1 = Player(firstName: "Bob", lastName: "Foo")
    let player2 = Player(firstName: "Fred", lastName: "Bar")
    
    let session = Session(
        currentPlayer: player1,
        opponents: [],
        opponent: player2,
        match: .init(player1: player1, player2: player2, board: "OO.XX.XO.")
    )
    BoardView(viewModel: BoardViewModel(session: session))
}
