//
//  BoardView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 06/10/2026.
//

import SwiftUI

struct BoardView: View {
    @State var viewModel = BoardViewModel(board: ".........")
    
    var body: some View {
        VStack {
            Text("Match")
                .font(.largeTitle)
            row
            row
            row
        }
        HStack {
            Button {
                viewModel.playMove()
            } label: {
                Text("Make move")
            }
        }
    }
    
    var tile: some View {
        Button {
            viewModel.toggleTile()
        } label: {
            Text("🅾️")
                .font(.largeTitle)
        }
    }
    
    var row: some View {
        HStack {
            tile
            tile
            tile
        }
    }
}

#Preview {
    BoardView()
}
