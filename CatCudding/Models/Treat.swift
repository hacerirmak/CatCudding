import SwiftUI

enum TreatType: CaseIterable {
    case fish, meat, shrimp, chicken

    var emoji: String {
        switch self {
        case .fish:    "🐟"
        case .meat:    "🍖"
        case .shrimp:  "🦐"
        case .chicken: "🍗"
        }
    }
    var happinessValue: Double {
        switch self {
        case .fish:    20
        case .meat:    30
        case .shrimp:  20
        case .chicken: 30
        }
    }
    var glowColor: Color {
        switch self {
        case .fish:    Color.cyan
        case .meat:    Color.red
        case .shrimp:  Color.orange
        case .chicken: Color.yellow
        }
    }
}

struct DraggableTreat: Identifiable {
    let id = UUID()
    let type: TreatType
    var position: CGPoint
    let startPosition: CGPoint
    var isEaten = false
    var opacity: Double = 1.0
    var scale: CGFloat = 1.0
    var isDragging = false
}
