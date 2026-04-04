import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.04, blue: 0.18),
                Color(red: 0.14, green: 0.05, blue: 0.28),
                Color(red: 0.20, green: 0.06, blue: 0.22)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }
}

struct AmbientGlow: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.appPurple.opacity(0.14))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: 120, y: -180)
            Circle()
                .fill(Color.appRose.opacity(0.10))
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .offset(x: -100, y: 200)
        }.allowsHitTesting(false)
    }
}
