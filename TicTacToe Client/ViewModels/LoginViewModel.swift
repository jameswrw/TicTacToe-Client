//
//  LoginViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import Foundation

@Observable
final class LoginViewModel {
    var userName = ""
    var password = ""
    var loggedInPlayer: Player? = nil

    func login() async {
        guard userName.count > 0, password.count > 0 else {
            loggedInPlayer = nil
            return
        }
        
        let credentials = Credentials(userName: userName, password: password)
        let coder = JSONEncoder()
        
        do {
            let body = try coder.encode(credentials)
            loggedInPlayer = try await Server.shared.request(
                url: TicTacToeAPI.login.rawValue,
                body: body,
                method: .post
            )
        } catch {
            loggedInPlayer = nil
        }
    }
}
