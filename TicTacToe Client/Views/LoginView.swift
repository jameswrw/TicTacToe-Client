//
//  LoginView.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import SwiftUI

struct LoginView: View {
    
    @State private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
            TextField("User name", text: $viewModel.userName)
            SecureField("Password", text: $viewModel.password)
            Button {
                Task {
                    let player = await viewModel.login()
                    print(player ?? "nil")
                }
            } label: {
                Text("Login")
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
