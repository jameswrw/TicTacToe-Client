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
                try await viewModel.fetchOpponents()
            } catch {
                print("Unable to fetch opponents: \(error)")
            }
        }
        .alert("Create Player", isPresented: $showCreatePlayer) {
            VStack {
                HStack {
                    TextField("User name", text: $viewModel.newPlayerUserName)
                    SecureField("Password", text: $viewModel.newPlayerPassword)
                    TextField("First name", text: $viewModel.newPlayerFirstName)
                    TextField("Last name", text: $viewModel.newPlayerLastName)
                }
                HStack {
                    Button("Create", role: .confirm) {
                        Task {
                            do {
                                try await viewModel.createPlayer(
                                    firstName: viewModel.newPlayerFirstName,
                                    lastName: viewModel.newPlayerLastName,
                                    userName: viewModel.newPlayerUserName,
                                    password: viewModel.newPlayerPassword
                                )
                            } catch {
                                print("Failed to create player")
                            }
                        }
                    }
                    .disabled(viewModel.newPlayerFirstName == "" || viewModel.newPlayerLastName == "")
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }
}

#Preview {
    PlayerListView(viewModel: PlayerListViewModel())
}
