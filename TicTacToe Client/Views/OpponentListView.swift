//
//  OpponentListVi.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI

struct OpponentListView: View {
    @Bindable var viewModel: OpponentListViewModel
    @State private var showCreatePlayer = false
    
    var body: some View {
        VStack {
            Text("Opponents")
                .font(.largeTitle)
            
            Table(viewModel.session.opponents, selection: $viewModel.session.opponent) {
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
        .padding()
        .alert("Create Player", isPresented: $showCreatePlayer) {
            VStack {
                TextField("User name", text: $viewModel.newPlayerUserName)
                SecureField("Password", text: $viewModel.newPlayerPassword)
                TextField("First name", text: $viewModel.newPlayerFirstName)
                TextField("Last name", text: $viewModel.newPlayerLastName)
                
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

#Preview {
    @Previewable @Environment(Session.self) var session
    OpponentListView(viewModel: OpponentListViewModel(session: session))
}
