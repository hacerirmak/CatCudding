import SwiftUI

enum TreatType: CaseIterable {
    case fish, meat, shrimp

    var emoji: String {
        switch self { case .fish: "🐟"; case .meat: "🍖"; case .shrimp: "🦐" }
    }
    var happinessValue: Double {
        switch self { case .fish: 15; case .meat: 25; case .shrimp: 20 }
    }
    var glowColor: Color {
        switch self { case .fish: Color.cyan; case .meat: Color.red; case .shrimp: Color.orange }
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
