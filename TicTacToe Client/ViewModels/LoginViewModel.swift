//
//  LoginViewModel.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 10/10/2026.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class LoginViewModel {
    var userName = ""
    var password = ""
    var session: Session

    init(session: Session) {
        self.session = session
    }

    func login(server: ServerProtocol, context: ModelContext) async {
        guard userName.count > 0, password.count > 0 else {
            session.currentPlayer = nil
            return
        }
        
        let credentials = Credentials(userName: userName, password: password)
        
        do {
            let dto = try await server.login(credentials: credentials)
            session.currentPlayer = Player(from: dto)
            try context.save()
        } catch {
            session.currentPlayer = nil
        }
    }
}
