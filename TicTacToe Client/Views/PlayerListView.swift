//
//  PlayerListView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI

struct PlayerListView: View {
    @State private var viewModel: PlayerListViewModel
    
    init(viewModel: PlayerListViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Players")
                .font(.largeTitle)
            
            Table(viewModel.players, selection: $viewModel.playerSelection) {
                TableColumn("First Name", value: \.firstName)
                TableColumn("Last Name", value: \.lastName)
            }
            .frame(minHeight: 120)
        }
        .task {
            do {
                try await viewModel.fetchPlayers()
            } catch {
                print("Unable to fetch players: \(error)")
            }
        }
    }
}

#Preview {
    PlayerListView(viewModel: PlayerListViewModel())
}
