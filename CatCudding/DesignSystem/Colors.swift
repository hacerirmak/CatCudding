import SwiftUI

extension Color {
    static let appRose   = Color(red: 1.00, green: 0.38, blue: 0.52)
    static let appCoral  = Color(red: 1.00, green: 0.58, blue: 0.28)
    static let appPurple = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let appBlue   = Color(red: 0.35, green: 0.55, blue: 0.98)

    static func cardBackground(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? .white.opacity(0.07) : .black.opacity(0.05)
    }
    static func cardBorder(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? .white.opacity(0.12) : .black.opacity(0.08)
    }
}
