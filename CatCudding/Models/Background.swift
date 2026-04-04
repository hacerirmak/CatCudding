import Foundation

struct GameBackground: Identifiable, Equatable {
    let id: String
    let name: String
    let emoji: String
    let imageName: String?   // nil = default gradient background
    let isUnlocked: Bool

    static func == (lhs: GameBackground, rhs: GameBackground) -> Bool { lhs.id == rhs.id }

    static let all: [GameBackground] = [
        GameBackground(id: "default", name: "Default", emoji: "🌌", imageName: nil,        isUnlocked: true),
        GameBackground(id: "meadow",  name: "Meadow",  emoji: "🌿", imageName: "bg_meadow", isUnlocked: true),
        GameBackground(id: "room",    name: "Room",    emoji: "🏠", imageName: "bg_room",   isUnlocked: true),
        GameBackground(id: "space",   name: "Space",   emoji: "🚀", imageName: "bg_space",  isUnlocked: true),
        GameBackground(id: "ocean",   name: "Ocean",   emoji: "🌊", imageName: "bg_ocean",  isUnlocked: true),
        GameBackground(id: "candy",   name: "Candy",   emoji: "🍭", imageName: "bg_candy",  isUnlocked: true),
    ]
}
