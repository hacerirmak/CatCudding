import SwiftUI

enum BackgroundScene: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case meadow    = "Meadow"
    case room      = "Room"
    case space     = "Space"
    case ocean     = "Ocean"
    case candy     = "Candy"

    var id: String { rawValue }

    var label: String { rawValue }

    var assetName: String {
        switch self {
        case .default: return "bg_default"
        case .meadow:  return "bg_meadow"
        case .room:    return "bg_room"
        case .space:   return "bg_space"
        case .ocean:   return "bg_ocean"
        case .candy:   return "bg_candy"
        }
    }

    var icon: String {
        switch self {
        case .default: return "sparkles"
        case .meadow:  return "leaf.fill"
        case .room:    return "house.fill"
        case .space:   return "moon.stars.fill"
        case .ocean:   return "water.waves"
        case .candy:   return "heart.fill"
        }
    }

    var fallbackGradient: LinearGradient {
        switch self {
        case .default:
            return LinearGradient(
                colors: [Color(red: 0.08, green: 0.05, blue: 0.20), Color(red: 0.20, green: 0.06, blue: 0.28)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .meadow:
            return LinearGradient(
                colors: [Color(red: 0.55, green: 0.82, blue: 0.45), Color(red: 0.27, green: 0.62, blue: 0.35)],
                startPoint: .top, endPoint: .bottom)
        case .room:
            return LinearGradient(
                colors: [Color(red: 1.00, green: 0.91, blue: 0.80), Color(red: 0.93, green: 0.80, blue: 0.65)],
                startPoint: .top, endPoint: .bottom)
        case .space:
            return LinearGradient(
                colors: [Color(red: 0.08, green: 0.04, blue: 0.32), Color(red: 0.22, green: 0.06, blue: 0.48)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        case .ocean:
            return LinearGradient(
                colors: [Color(red: 0.10, green: 0.55, blue: 0.85), Color(red: 0.04, green: 0.28, blue: 0.60)],
                startPoint: .top, endPoint: .bottom)
        case .candy:
            return LinearGradient(
                colors: [Color(red: 1.00, green: 0.78, blue: 0.88), Color(red: 0.90, green: 0.58, blue: 0.88)],
                startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
