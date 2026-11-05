//
//  LoginView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @Environment(Session.self) var session
    @Environment(\.modelContext) private var context
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
                    await viewModel.login()
                    if let player = session.currentPlayer {
                        context.insert(player)
                        await opponentListViewModel.fetchOpponents(playerID: player.id, context: context)
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
    @Previewable @Environment(Session.self) var session
    LoginView(
        viewModel: LoginViewModel(session: session),
        playerViewModel: OpponentListViewModel(session: session)
    )
}
