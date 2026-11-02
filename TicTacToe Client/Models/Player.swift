//
//  Player.swift
//  TicTacToe Client
//
//  Converted to SwiftData @Model
//

import Foundation
import SwiftData

@Model
final class Player: Identifiable {
    // Persisted properties
    @Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String

    var name: String {
        [firstName, lastName].joined(separator: " ")
    }
    
    // MARK: - Init
    init(id: UUID = UUID(), firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(from dto: PlayerDTO) {
        self.id = dto.id
        self.firstName = dto.firstName
        self.lastName = dto.lastName
    }
}
