//
//  MatchListView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI
import SwiftData

struct MatchListView: View {
    @Bindable var viewModel: MatchListViewModel
    @State private var showCreateMatch = false
    @Environment(\.modelContext) private var context
    @Environment(Server.self) private var server
    
    var body: some View {
        VStack {

            Table(viewModel.matches, selection: $viewModel.selectedMatchID) {
                TableColumn("Player 1") { match in
                    Text(match.player1.name)
                }
                TableColumn("Player 2") { match in
                    Text(match.player2.name)
                }
                TableColumn("Winner") { match in
                    Text(match.winner?.name ?? "—")
                }
            }
            .frame(minHeight: 120)
            
            Button {
                showCreateMatch = true
            } label: {
                Text("New match")
            }
        }
        .padding()
        .onChange(of: viewModel.session.opponent) { _, _ in
            Task {
                do {
                    try await viewModel.fetchMatches(usingContext: context, server: server)
                    viewModel.matches.forEach { context.insert($0) }
                } catch {
                    print("Unable to fetch matches: \(error)")
                }
            }
        }
        .task {
            do {
                try await viewModel.fetchMatches(usingContext: context, server: server)
            } catch {
                print("Unable to fetch players: \(error)")
            }
        }
        .alert("Create Match", isPresented: $showCreateMatch) {
            VStack {
                Button("Create", role: .confirm) {
                    Task {
                        do {
                            if let match = try await viewModel.createMatch(withContext: context, server: server) {
                                context.insert(match)
                            }
                        } catch {
                            print("Failed to create match")
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

#Preview {
    @Previewable @Environment(Session.self) var session
    MatchListView(viewModel: MatchListViewModel(session: session))
}
