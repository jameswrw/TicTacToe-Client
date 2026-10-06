//
//  PlayerListView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI

struct PlayerListView: View {
    @State private var viewModel: PlayerListViewModel
    @State private var showCreatePlayer = false
    @State private var newPlayerFirstName = ""
    @State private var newPlayerLastName = ""

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
            
            Button {
                showCreatePlayer = true
            } label: {
                Text("New player")
            }

        }
        .task {
            do {
                try await viewModel.fetchPlayers()
            } catch {
                print("Unable to fetch players: \(error)")
            }
        }
        .alert("Create Player", isPresented: $showCreatePlayer) {
            VStack {
                HStack {
                    TextField("First name", text: $newPlayerFirstName)
                    TextField("Last name", text: $newPlayerLastName)
                }
                HStack {
                    Button("Create", role: .confirm) {
                        Task {
                            do {
                                let newPlayer = try await viewModel.createPlayer(firstName: newPlayerFirstName, lastName: newPlayerLastName)
                                print(newPlayer)
                            } catch {
                                print("Failed to create player")
                            }
                        }
                    }
                    .disabled(newPlayerFirstName == "" || newPlayerLastName == "")
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }
}

#Preview {
    PlayerListView(viewModel: PlayerListViewModel())
}
