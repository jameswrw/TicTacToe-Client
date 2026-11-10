//
//  LoginView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import SwiftUI
import SwiftData
import Dependencies

struct LoginView: View {
    
    @Environment(Session.self) var session
    @Environment(\.modelContext) private var context
    @Dependency(\.server) private var server
    @State private var viewModel: LoginViewModel
    
    var opponentListViewModel: OpponentListViewModel
        
    init(viewModel: LoginViewModel, playerViewModel: OpponentListViewModel) {
        self._viewModel = State(initialValue: viewModel)
        self.opponentListViewModel = playerViewModel
    }
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
            TextField("User name", text: $viewModel.userName)
            SecureField("Password", text: $viewModel.password)
            Button {
                Task {
                    await viewModel.login(server: server, context: context)
                    if let player = session.currentPlayer {
                        context.insert(player)
                        await opponentListViewModel.fetchOpponents(playerID: player.id, context: context, server: server)
                    }
                }
            } label: {
                Text("Login")
            }
            .disabled(viewModel.userName.count == 0 || viewModel.password.count == 0)
        }
        .padding()
    }
}

#Preview {
    @Dependency(\.server) var server
    
    let p1 = Player(firstName: "Place", lastName: "Holder")
    let p2 = Player(firstName: "Someone", lastName: "Else")

    let session = Session(
        currentPlayer: p1,
        opponents: [p2],
        opponent: p2,
        match: .init(player1: p1, player2: p2, board: "OO..XXO.X")
    )
    LoginView(
        viewModel: LoginViewModel(session: session),
        playerViewModel: OpponentListViewModel(session: session)
    )
}
