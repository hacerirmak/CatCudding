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
enum GameMode: Identifiable { case cuddle, treats, toys; var id: Self { self } }

enum CustomCatUploadError: Identifiable {
    case loadFailed, bgRemovalFailed, unsupported, permissionDenied
    var id: Self { self }
}

extension GameMode {
    var displayName: String {
        switch self { case .cuddle: "Cuddle"; case .treats: "Treats"; case .toys: "Wand" }
    }
    var modeEmoji: String {
        switch self { case .cuddle: "🐾"; case .treats: "🍪"; case .toys: "🧶" }
    }
    var subtitle: String {
        switch self {
        case .cuddle: "Soft strokes · relaxing"
        case .treats: "Snacks & rewards · medium"
        case .toys: "Feather wand · active"
        }
    }
    var toneColor: Color {
        switch self { case .cuddle: .ccPink; case .treats: .ccMint; case .toys: .ccSky }
    }
}
