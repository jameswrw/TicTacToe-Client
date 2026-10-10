//
//  LoginViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import Foundation

struct LoginViewModel {
    var userName = ""
    var password = ""
    
    func login() async -> Player? {
        guard userName.count > 0, password.count > 0 else { return nil }
        let credentials = Credentials(userName: userName, password: password)
        let coder = JSONEncoder()
        var player: Player? = nil
        
        do {
            let body = try coder.encode(credentials)
            player = try await Server.shared.request(
                url: TicTacToeAPI.login.rawValue,
                body: body,
                method: .post
            )
        } catch {
            player = nil
        }
        return player
    }
}
