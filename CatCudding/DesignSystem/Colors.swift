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

    // Design system tokens
    static let ccPeach      = Color(red: 1.000, green: 0.541, blue: 0.357) // #FF8A5B
    static let ccPeachDeep  = Color(red: 0.914, green: 0.416, blue: 0.239) // #E96A3D
    static let ccInk        = Color(red: 0.165, green: 0.122, blue: 0.102) // #2A1F1A
    static let ccInk2       = Color(red: 0.361, green: 0.290, blue: 0.247) // #5C4A3F
    static let ccInk3       = Color(red: 0.612, green: 0.549, blue: 0.510) // #9C8C82
    static let ccBg         = Color(red: 1.000, green: 0.973, blue: 0.933) // #FFF8EE
    static let ccBgAlt      = Color(red: 1.000, green: 0.937, blue: 0.851) // #FFEFD9
    static let ccWarnBg     = Color(red: 1.000, green: 0.945, blue: 0.839) // #FFF1D6
    static let ccDanger     = Color(red: 0.898, green: 0.322, blue: 0.247) // #E5523F
    static let ccDangerBg   = Color(red: 1.000, green: 0.906, blue: 0.882) // #FFE7E1
    static let ccLine       = Color(red: 0.941, green: 0.886, blue: 0.808) // #F0E2CE
    static let ccLineStrong = Color(red: 0.882, green: 0.804, blue: 0.694) // #E1CDB1
    static let ccPink       = Color(red: 1.000, green: 0.710, blue: 0.773) // #FFB5C5
    static let ccSky        = Color(red: 0.733, green: 0.851, blue: 0.949) // #BBD9F2
    static let ccMint       = Color(red: 0.722, green: 0.902, blue: 0.788) // #B8E6C9
}
