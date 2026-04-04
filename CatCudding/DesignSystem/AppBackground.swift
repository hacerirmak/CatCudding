import SwiftUI

struct AppBackground: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.04, blue: 0.18),
                        Color(red: 0.14, green: 0.05, blue: 0.28),
                        Color(red: 0.20, green: 0.06, blue: 0.22)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.95, blue: 1.00),
                        Color(red: 1.00, green: 0.96, blue: 0.97),
                        Color(red: 0.96, green: 0.95, blue: 1.00)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
    }
}

struct AmbientGlow: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.appPurple.opacity(colorScheme == .dark ? 0.14 : 0.08))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: 120, y: -180)
            Circle()
                .fill(Color.appRose.opacity(colorScheme == .dark ? 0.10 : 0.07))
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .offset(x: -100, y: 200)
        }.allowsHitTesting(false)
    }
}
