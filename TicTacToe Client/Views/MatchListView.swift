//
//  MatchListView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI

struct MatchListView: View {
    @Bindable var viewModel: MatchListViewModel
    @State private var showCreateMatch = false

    var body: some View {
        VStack {
            Text("Matches")
                .font(.largeTitle)
            
            Table(viewModel.matches, selection: $viewModel.matchSelection) {
                TableColumn("Player One", value: \.player1)
                TableColumn("Player Two", value: \.player2)
                TableColumn("Winner") { match in
                    Text(match.winnner ?? "—")
                }
                TableColumn("Board", value: \.board)
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
                viewModel.matches = []
                viewModel.matchSelection = nil
                try? await viewModel.fetchMatches()
            }
        }
        .task {
            do {
                try await viewModel.fetchMatches()
            } catch {
                print("Unable to fetch players: \(error)")
            }
        }
        .alert("Create Match", isPresented: $showCreateMatch) {
            VStack {
                Button("Create", role: .confirm) {
                    Task {
                        do {
                            try await viewModel.createMatch()
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
