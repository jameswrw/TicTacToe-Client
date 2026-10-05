//
//  PlayerListView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI

struct PlayerListView: View {
    @State private var viewModel = PlayerListViewModel()
    
    var body: some View {
        VStack {
            Text("Players")
                .font(.largeTitle)
            
            Table(viewModel.players) {
                TableColumn("First Name", value: \.firstName)
                TableColumn("Last Name", value: \.lastName)
            }
            .lineLimit(3)
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
    PlayerListView()
}
