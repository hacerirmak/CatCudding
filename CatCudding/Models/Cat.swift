import SwiftUI

struct Cat: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let breed: String
    let color: Color
    let emoji: String
    let isCustom: Bool

    init(name: String, description: String, breed: String, color: Color, emoji: String, isCustom: Bool = false) {
        self.name = name
        self.description = description
        self.breed = breed
        self.color = color
        self.emoji = emoji
        self.isCustom = isCustom
    }

    static func == (lhs: Cat, rhs: Cat) -> Bool { lhs.id == rhs.id }
}

enum ScreenType { case welcome, selection, game }
enum GameMode { case cuddle, treats, toys }
