//
//  ServerDependency.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 09/11/2026.
//

import Dependencies
import DependenciesMacros
import Foundation

extension DependencyValues {
    @DependencyEntry(liveValue: { @Sendable in
        Server(baseURL: URL(string: TicTacToeAPI.baseURL.rawValue)!)
    }())
    nonisolated var server: any ServerProtocol = { @Sendable in
        TestServer()
    }()
}
