//
//  ServerDependency.swift
//  TicTacToe Client
//
//  Created by James Weatherley on 09/11/2026.
//

import Dependencies
import DependenciesMacros
import Foundation

nonisolated private enum ServerKey: DependencyKey {
    static let liveValue: ServerProtocol = Server(baseURL: URL(string: TicTacToeAPI.baseURL.rawValue)!)
    static let testValue: ServerProtocol = TestServer()
    static let previewValue: ServerProtocol = PreviewServer()
}

extension DependencyValues {
    nonisolated var server: ServerProtocol {
      get { self[ServerKey.self] }
      set { self[ServerKey.self] = newValue }
    }}
