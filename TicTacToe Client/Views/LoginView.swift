//
//  LoginView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(Session.self) var session
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
                        await opponentListViewModel.fetchOpponents(playerID: player.id)
                    }
                }
            } label: {
                Text("Login")
            }
            if let player = session.currentPlayer {
                Text(player.firstName)
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @Environment(Session.self) var session
    LoginView(viewModel: LoginViewModel(session: session), playerViewModel: OpponentListViewModel())
}
