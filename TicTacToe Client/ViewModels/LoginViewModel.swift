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
        
        do {
            let player = try await Server.shared.login(credentials: credentials)
            session.currentPlayer = player
        } catch {
            session.currentPlayer = nil
        }
    }
}
