import SwiftUI

struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState

    @State private var appear = false

    // Frame position in the 1024×1536 source image (measured in pixels)
    private let frameTopPct:    CGFloat = 0.400
    private let frameBottomPct: CGFloat = 0.800
    private let frameLeftPct:   CGFloat = 0.060
    private let frameRightPct:  CGFloat = 0.940

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let frameX       = w * frameLeftPct
            let frameW       = w * (frameRightPct - frameLeftPct)
            let frameY       = h * frameTopPct
            let frameH       = h * (frameBottomPct - frameTopPct)
            let frameCenterX = frameX + frameW / 2
            let frameCenterY = frameY + frameH / 2
            let catSize      = min(frameW, frameH) * 0.90

            ZStack {
                Image("amazing_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()
                    .ignoresSafeArea()

                CatImageView(imageSource: imageSource)
                    .frame(width: catSize, height: catSize)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .position(x: frameCenterX, y: frameCenterY)
                    .scaleEffect(appear ? 1.0 : 0.75)
                    .opacity(appear ? 1 : 0)

                // X pill — top right, 44×44
                VStack {
                    HStack {
                        Spacer()
                        Button(action: dismiss) {
                            Image(systemName: "xmark")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.ccInk)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.95))
                                .clipShape(Circle())
                                .shadow(color: Color(red: 42/255, green: 31/255, blue: 26/255).opacity(0.18), radius: 12, x: 0, y: 4)
                        }
                        .buttonStyle(ScalePressStyle())
                        .padding(.top, 60)
                        .padding(.trailing, 16)
                    }
                    Spacer()
                }
                .zIndex(5)

                // Stats card + CTAs anchored to bottom
                VStack(spacing: 8) {
                    Spacer()

                    // Stats card
                    HStack(spacing: 0) {
                        CelebrationStat(value: "\(Int(gameState.happiness))%", label: "Happiness")
                        Divider()
                            .frame(height: 36)
                            .background(Color.ccLine)
                        CelebrationStat(value: gameState.sessionDurationFormatted, label: "Time")
                        Divider()
                            .frame(height: 36)
                            .background(Color.ccLine)
                        CelebrationStat(value: "\(gameState.streak) 🔥", label: "Day streak")
                    }
                    .padding(.vertical, 14)
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: Color(red: 42/255, green: 31/255, blue: 26/255).opacity(0.20), radius: 30, x: 0, y: 12)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 16)
                    .padding(.horizontal, 20)

                    // Continue CTA
                    Button(action: dismiss) {
                        HStack(spacing: 6) {
                            Text("Continue")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                            Text("→")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .foregroundColor(.ccPeachDeep)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: Color(red: 42/255, green: 31/255, blue: 26/255).opacity(0.10), radius: 0, x: 0, y: 3)
                    }
                    .buttonStyle(ScalePressStyle())
                    .padding(.horizontal, 20)

                    // Back to Home (secondary ghost)
                    Button(action: goHome) {
                        Text("Back to Home")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .buttonStyle(ScalePressStyle())
                    .padding(.bottom, 40)
                }
                .zIndex(5)
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
                gameState.startSession()
            }
        }
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            gameState.showFullScreenCelebration = false
            gameState.happiness = 0
        }
    }

    private func goHome() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            gameState.showFullScreenCelebration = false
            gameState.resetGame()
            gameState.currentScreen = .welcome
        }
    }
}

private struct CelebrationStat: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.ccInk)
            Text(label)
                .font(.system(size: 11.5, weight: .semibold))
                .foregroundColor(.ccInk3)
        }
        .frame(maxWidth: .infinity)
    }
}
