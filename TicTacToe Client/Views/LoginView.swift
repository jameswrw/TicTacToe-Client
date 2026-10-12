//
//  LoginView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import SwiftUI

struct LoginView: View {
    
    @State private var viewModel: LoginViewModel
    private var playerViewModel: PlayerListViewModel
    
    init(viewModel: LoginViewModel, playerViewModel: PlayerListViewModel) {
        self._viewModel = State(initialValue: viewModel)
        self.playerViewModel = playerViewModel
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
                    if let player = viewModel.loggedInPlayer {
                        await playerViewModel.fetchOpponents(playerID: player.id)
                    }
                }
            } label: {
                Text("Login")
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(), playerViewModel: PlayerListViewModel())
}
