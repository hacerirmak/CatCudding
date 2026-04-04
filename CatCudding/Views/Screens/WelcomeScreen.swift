import SwiftUI

struct WelcomeScreen: View {
    @ObservedObject var gameState: GameState
    @State private var logoFloat: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 28
    @State private var pawOpacity: Double = 0
    @State private var pawDrift: [CGSize] = (0..<6).map { _ in
        CGSize(width: CGFloat.random(in: -10...10), height: CGFloat.random(in: 0...15))
    }

    private let pawSeeds: [(CGFloat, CGFloat, Double)] = [
        (0.14, 0.11, -14), (0.83, 0.09, 18), (0.08, 0.54, 9),
        (0.88, 0.47, -7),  (0.21, 0.82, 24), (0.76, 0.77, -18)
    ]

    var body: some View {
        ZStack {
            AppBackground()
            AmbientGlow()

            GeometryReader { geo in
                ForEach(0..<pawSeeds.count, id: \.self) { i in
                    let (xr, yr, angle) = pawSeeds[i]
                    Text("🐾")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.10))
                        .rotationEffect(.degrees(angle))
                        .position(x: geo.size.width * xr + pawDrift[i].width, y: geo.size.height * yr + pawDrift[i].height)
                        .opacity(pawOpacity)
                }
            }

            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.appRose.opacity(0.25), Color.appPurple.opacity(0.18)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 130, height: 130).blur(radius: 20)
                    Circle()
                        .fill(Color.white.opacity(0.07))
                        .frame(width: 110, height: 110)
                        .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
                    Text("🐱").font(.system(size: 58))
                }
                .offset(y: logoFloat)
                .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: logoFloat)

                Spacer().frame(height: 32)

                VStack(spacing: 10) {
                    Text("Cat Cuddle")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Tap the button to start cuddling\nsome adorable kittens!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.62))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .opacity(contentOpacity).offset(y: contentOffset)

                Spacer().frame(height: 44)

                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        gameState.currentScreen = .selection
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("Play Now").font(.system(size: 18, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.right").font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white).frame(width: 200, height: 56)
                    .background(LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: Color.appRose.opacity(0.45), radius: 16, x: 0, y: 8)
                }
                .buttonStyle(ScalePressStyle())
                .opacity(contentOpacity).offset(y: contentOffset)

                Spacer()

                Text("© 2025 CatCudding")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.22))
                    .padding(.bottom, 32)
                    .opacity(contentOpacity)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true).delay(0.3)) { logoFloat = -10 }
            withAnimation(.easeOut(duration: 0.7).delay(0.3)) { contentOpacity = 1; contentOffset = 0 }
            withAnimation(.easeIn(duration: 1.0).delay(0.5)) { pawOpacity = 1 }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true).delay(0.6)) {
                for i in pawDrift.indices {
                    pawDrift[i] = CGSize(width: .random(in: -12...12), height: .random(in: -18...8))
                }
            }
        }
    }
}
