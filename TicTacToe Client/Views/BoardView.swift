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
        VStack {
            Text("Match")
                .font(.largeTitle)
            row(0)
            row(1)
            row(2)
        }
        .padding()

        HStack {
            Button {
                viewModel.playMove()
            } label: {
                Text("Make move")
            }
        }
        .padding()
    }
    
    func tile(row: Int, col: Int) -> some View {
        Button {
            viewModel.toggleTile()
        } label: {
            Text(viewModel.tileValue(row: row, col: col))
                .font(.largeTitle)
                .frame(width: 50, height: 50)
        }
    }
    
    func row(_ row: Int) -> some View {
        HStack {
            tile(row: row, col: 0)
            tile(row: row, col: 1)
            tile(row: row, col: 2)
        }
    }
}

#Preview {
    BoardView(viewModel: BoardViewModel(board: "OXOXXOX.."))
}
