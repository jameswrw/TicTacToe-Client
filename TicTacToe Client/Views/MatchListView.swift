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

    var body: some View {
        VStack {

            // Bridge selection between Match? and Table's UUID? selection
            let selectionBinding = Binding<UUID?>(
                get: { viewModel.session.match?.id },
                set: { newID in
                    if let id = newID {
                        viewModel.session.match = viewModel.matches.first { $0.id == id }
                    } else {
                        viewModel.session.match = nil
                    }
                }
            )
            
            Table(viewModel.matches, selection: selectionBinding) {
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
                    try await viewModel.fetchMatches(usingContext: context)
                    viewModel.matches.forEach { context.insert($0) }
                } catch {
                    print("Unable to fetch matches: \(error)")
                }
            }
        }
        .task {
            do {
                try await viewModel.fetchMatches(usingContext: context)
            } catch {
                print("Unable to fetch players: \(error)")
            }
        }
        .alert("Create Match", isPresented: $showCreateMatch) {
            VStack {
                Button("Create", role: .confirm) {
                    Task {
                        do {
                            if let match = try await viewModel.createMatch(withContext: context) {
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
    let container = try! ModelContainer(for: Session.self, Player.self, Match.self)
    let context = ModelContext(container)
    MatchListView(viewModel: MatchListViewModel(session: session))
}
