//
//  BoardView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 06/10/2026.
//

import SwiftUI

struct BoardView: View {
    @State var viewModel: BoardViewModel
    
    init(viewModel: BoardViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        grid()

        HStack {
            Button {
                viewModel.playMove()
            } label: {
                Text("Play move")
            }
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
            Text("Match")
                .font(.largeTitle)
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
            var symbol = viewModel.tileValue(row: row, col: col)
            if viewModel.isCandidateMove(row: row, col: col) {
                symbol = viewModel.candidateMove?.symbol ?? .empty
            }
            
            return Text(symbol.rawValue)
                .font(.largeTitle)
                .frame(width: 50, height: 50)
        }
        .background(viewModel.tileBackground(row: row, col: col))
    }
}

#Preview {
    @Previewable @Environment(Session.self) var session
    BoardView(viewModel: BoardViewModel(session: session, board: "OXOXXOX.."))
}
