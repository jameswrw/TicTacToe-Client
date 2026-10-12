//
//  LoginViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import Foundation
import SwiftUI

@Observable
final class LoginViewModel {
    var userName = ""
    var password = ""
    var session: Session

    init(session: Session) {
        self.session = session
    }

    func login() async {
        guard userName.count > 0, password.count > 0 else {
            session.currentPlayer = nil
            return
        }
        
        let credentials = Credentials(userName: userName, password: password)
        let coder = JSONEncoder()
        
        do {
            let body = try coder.encode(credentials)
            session.currentPlayer = try await Server.shared.request(
                url: TicTacToeAPI.login.rawValue,
                body: body,
                method: .post
            )
        } catch {
            session.currentPlayer = nil
        }
    }
}
