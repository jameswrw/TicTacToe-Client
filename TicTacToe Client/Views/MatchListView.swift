//
//  MatchListView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 05/10/2026.
//

import SwiftUI

struct MatchListView: View {
    @State private var viewModel = MatchListViewModel()
    
    var body: some View {
        VStack {
            Text("Matches")
                .font(.largeTitle)
            
            Table(viewModel.matches) {
                TableColumn("Player One", value: \.player1)
                TableColumn("Player Two", value: \.player2)
                TableColumn("Winner") { match in
                    Text(match.winnner ?? "—")
                }
                TableColumn("Board", value: \.board)
            }
            .lineLimit(3)
        }
        .task {
            do {
                try await viewModel.fetchMatches()
            } catch {
                print("Unable to fetch players: \(error)")
            }
        }
    }
}

#Preview {
    MatchListView()
}
