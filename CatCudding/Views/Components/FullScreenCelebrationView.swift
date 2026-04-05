import SwiftUI

struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState
    @Environment(\.colorScheme) var colorScheme

    @State private var appear = false
    @State private var pulse = false
    @State private var confetti: [ConfettiPiece] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                if colorScheme == .dark {
                    Color(red: 0.06, green: 0.04, blue: 0.16).ignoresSafeArea()
                    // Dark purple cloud blobs
                    Circle().fill(Color(red: 0.18, green: 0.10, blue: 0.38).opacity(0.7))
                        .frame(width: 300).blur(radius: 50).offset(x: -60, y: geo.size.height * 0.3)
                    Circle().fill(Color(red: 0.14, green: 0.08, blue: 0.32).opacity(0.6))
                        .frame(width: 260).blur(radius: 45).offset(x: geo.size.width * 0.4, y: geo.size.height * 0.55)
                } else {
                    LinearGradient(
                        colors: [
                            Color(red: 0.45, green: 0.18, blue: 0.60),
                            Color(red: 0.60, green: 0.15, blue: 0.45),
                            Color(red: 0.50, green: 0.10, blue: 0.50)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).ignoresSafeArea()
                    // Pink cloud blobs
                    Circle().fill(Color(red: 0.85, green: 0.55, blue: 0.75).opacity(0.4))
                        .frame(width: 280).blur(radius: 50).offset(x: -40, y: geo.size.height * 0.35)
                    Circle().fill(Color(red: 0.80, green: 0.45, blue: 0.70).opacity(0.35))
                        .frame(width: 240).blur(radius: 45).offset(x: geo.size.width * 0.45, y: geo.size.height * 0.55)
                }

                // Confetti
                ForEach(confetti) { piece in
                    Text(piece.emoji)
                        .font(.system(size: piece.size))
                        .position(x: piece.x, y: piece.y)
                        .opacity(piece.opacity)
                        .rotationEffect(.degrees(piece.rotation))
                }

                // Stars scattered
                ForEach(0..<12, id: \.self) { i in
                    Text("✦")
                        .font(.system(size: CGFloat([8, 10, 12, 6, 9, 11, 7, 13, 8, 10, 6, 9][i])))
                        .foregroundColor(.yellow.opacity(0.8))
                        .position(
                            x: [50, 320, 80, 370, 160, 400, 30, 350, 120, 380, 200, 420][i],
                            y: CGFloat([80, 60, 300, 120, 500, 350, 600, 700, 150, 500, 250, 650][i])
                        )
                        .opacity(appear ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(Double(i) * 0.08), value: appear)
                }

                VStack(spacing: 0) {
                    // Title
                    Text("🎉 Amazing! 🎉")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        .scaleEffect(pulse ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: pulse)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 24)
                        .padding(.top, 56)

                    Text("\(catName) is super happy!")
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.90))
                        .multilineTextAlignment(.center)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 16)
                        .padding(.top, 10)

                    Spacer()

                    // Main card
                    ZStack(alignment: .top) {
                        // Card background
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(
                                colorScheme == .dark
                                ? LinearGradient(colors: [Color(red: 0.12, green: 0.06, blue: 0.28), Color(red: 0.18, green: 0.08, blue: 0.38)], startPoint: .top, endPoint: .bottom)
                                : LinearGradient(colors: [Color(red: 0.62, green: 0.20, blue: 0.55), Color(red: 0.52, green: 0.14, blue: 0.48)], startPoint: .top, endPoint: .bottom)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .stroke(
                                        LinearGradient(colors: [Color(red: 1.0, green: 0.80, blue: 0.30), Color(red: 0.90, green: 0.60, blue: 0.10)],
                                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                                        lineWidth: 2.5
                                    )
                            )
                            .shadow(color: Color(red: 1.0, green: 0.75, blue: 0.20).opacity(0.4), radius: 20, x: 0, y: 4)

                        VStack(spacing: 0) {
                            // Top ribbon space
                            Color.clear.frame(height: 24)

                            // Cat image
                            CatImageView(imageSource: imageSource)
                                .frame(width: geo.size.width * 0.62, height: geo.size.width * 0.62)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .padding(.horizontal, 20)
                                .padding(.bottom, 16)

                            // Bottom ribbon space
                            Color.clear.frame(height: 28)
                        }

                        // Top golden ribbon banner
                        GoldenBanner(text: "Perfect Happiness!")
                            .frame(width: geo.size.width * 0.72)
                            .offset(y: -18)

                        // Bottom pink ribbon banner
                        PinkBanner(text: "💕 Perfect Happiness Achieved! 💕")
                            .frame(width: geo.size.width * 0.72)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .offset(y: 18)
                    }
                    .frame(width: geo.size.width * 0.82)
                    .scaleEffect(appear ? 1.0 : 0.82)
                    .opacity(appear ? 1 : 0)

                    Spacer()

                    // Subtitle
                    Text("You've made \(catName) the happiest cat ever!")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.80))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 10)

                    // Continue button
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.showFullScreenCelebration = false
                            gameState.happiness = 0
                        }
                    }) {
                        Text("Continue Playing")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.35, green: 0.18, blue: 0.05))
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.88, blue: 0.55), Color(red: 0.98, green: 0.76, blue: 0.30)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color(red: 0.85, green: 0.60, blue: 0.15).opacity(0.6), lineWidth: 1.5))
                            .shadow(color: Color(red: 1.0, green: 0.75, blue: 0.20).opacity(0.5), radius: 12, x: 0, y: 4)
                    }
                    .buttonStyle(ScalePressStyle())
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    .padding(.bottom, 44)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 20)
                }
                .padding(.horizontal, 24)
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
                withAnimation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true).delay(0.6)) { pulse = true }
                spawnConfetti(in: geo.size)
            }
        }
    }

    private func spawnConfetti(in size: CGSize) {
        let emojis = ["🎊", "🎉", "✨", "⭐️", "💫", "🌟"]
        confetti = (0..<30).map { i in
            ConfettiPiece(
                emoji: emojis[i % emojis.count],
                x: .random(in: 0...size.width),
                y: .random(in: 0...size.height),
                size: .random(in: 14...26),
                opacity: .random(in: 0.5...0.95),
                rotation: .random(in: -45...45)
            )
        }
    }
}

private struct GoldenBanner: View {
    let text: String
    var body: some View {
        ZStack {
            // Banner ribbon
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LinearGradient(
                    colors: [Color(red: 1.0, green: 0.82, blue: 0.32), Color(red: 0.88, green: 0.62, blue: 0.10)],
                    startPoint: .top, endPoint: .bottom
                ))
                .frame(height: 38)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color(red: 0.75, green: 0.50, blue: 0.05), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
            Text(text)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.35, green: 0.15, blue: 0.02))
        }
    }
}

private struct PinkBanner: View {
    let text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LinearGradient(
                    colors: [Color(red: 0.85, green: 0.22, blue: 0.45), Color(red: 0.70, green: 0.15, blue: 0.35)],
                    startPoint: .top, endPoint: .bottom
                ))
                .frame(height: 38)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color(red: 0.60, green: 0.10, blue: 0.25), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
            Text(text)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

private struct ConfettiPiece: Identifiable {
    let id = UUID()
    let emoji: String
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
    let rotation: Double
}
