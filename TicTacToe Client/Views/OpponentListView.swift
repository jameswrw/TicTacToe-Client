//
//  OpponentListVi.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI
import SwiftData

struct OpponentListView: View {
    @Bindable var viewModel: OpponentListViewModel
    @State private var showCreatePlayer = false
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack {
            Text("Opponents")
                .font(.largeTitle)
            
            // Bridge selection between Player? and Table's UUID? selection
            let selectionBinding = Binding<UUID?>(
                get: { viewModel.session.opponent?.id },
                set: { newID in
                    if let id = newID {
                        viewModel.session.opponent = viewModel.session.opponents.first { $0.id == id }
                    } else {
                        viewModel.session.opponent = nil
                    }
                }
            )
            
            Table(viewModel.session.opponents, selection: selectionBinding) {
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

