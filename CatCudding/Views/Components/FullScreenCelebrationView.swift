import SwiftUI

struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState
    @State private var floatHearts: [FloatingElement] = []
    @State private var floatSparkles: [FloatingElement] = []
    @State private var appear = false
    @State private var pulse = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.10, green: 0.03, blue: 0.22),
                        Color(red: 0.25, green: 0.05, blue: 0.35),
                        Color(red: 0.35, green: 0.08, blue: 0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()

                Circle().fill(Color.appRose.opacity(0.15)).frame(width: 300, height: 300).blur(radius: 60).offset(x: -80, y: -200)
                Circle().fill(Color.appPurple.opacity(0.12)).frame(width: 250, height: 250).blur(radius: 50).offset(x: 100, y: 200)

                ForEach(floatHearts) { h in Text("🐾").font(.system(size: 22)).position(x: h.x, y: h.y).opacity(h.opacity) }
                ForEach(floatSparkles) { s in Text("✨").font(.system(size: 18)).position(x: s.x, y: s.y).opacity(s.opacity) }

                VStack(spacing: 28) {
                    Text("🎉 Amazing! 🎉")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .scaleEffect(pulse ? 1.06 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                        .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 20)
                        .padding(.top, 60)

                    Text("\(catName) is super happy!")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 15)

                    CatImageView(imageSource: imageSource)
                        .frame(maxWidth: geo.size.width * 0.72, maxHeight: geo.size.height * 0.42)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(LinearGradient(colors: [.appRose, .appPurple], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                        )
                        .shadow(color: Color.appRose.opacity(0.35), radius: 24, x: 0, y: 8)
                        .scaleEffect(appear ? 1.0 : 0.7).opacity(appear ? 1 : 0)

                    VStack(spacing: 8) {
                        Text("💖 Perfect Happiness Achieved! 💖")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white).multilineTextAlignment(.center)
                        Text("You've made \(catName) the happiest cat ever!")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.7)).multilineTextAlignment(.center)
                    }
                    .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 10)

                    Spacer()

                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.showFullScreenCelebration = false
                            gameState.happiness = 0
                        }
                    }) {
                        Text("Continue Playing")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                            .shadow(color: Color.appRose.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .buttonStyle(ScalePressStyle())
                    .padding(.horizontal, 32).padding(.bottom, 44)
                    .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 20)
                }
                .padding(.horizontal, 24)
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.5)) { pulse = true }
                generateEffects(in: geo.size)
            }
        }
    }

    private func generateEffects(in size: CGSize) {
        for i in 0..<18 {
            let h = FloatingElement(x: .random(in: 0...size.width), y: .random(in: 0...size.height))
            floatHearts.append(h)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.12) {
                withAnimation(.easeOut(duration: 3.0)) {
                    if let idx = floatHearts.firstIndex(where: { $0.id == h.id }) {
                        floatHearts[idx] = FloatingElement(x: h.x + .random(in: -80...80), y: h.y - 220, opacity: 0)
                    }
                }
            }
        }
        for i in 0..<25 {
            let s = FloatingElement(x: .random(in: 0...size.width), y: .random(in: 0...size.height))
            floatSparkles.append(s)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    if let idx = floatSparkles.firstIndex(where: { $0.id == s.id }) {
                        floatSparkles[idx] = FloatingElement(x: s.x + .random(in: -120...120), y: s.y - 130, opacity: 0)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            floatHearts.removeAll()
            floatSparkles.removeAll()
        }
    }
}
