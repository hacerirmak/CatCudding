import SwiftUI

struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState

    @State private var appear = false

    // Frame position in the 1024×1536 source image (measured in pixels)
    private let frameTopPct:    CGFloat = 0.400   // ~614 / 1536
    private let frameBottomPct: CGFloat = 0.800   // ~1229 / 1536
    private let frameLeftPct:   CGFloat = 0.060   // ~61  / 1024
    private let frameRightPct:  CGFloat = 0.940   // ~963 / 1024

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // Computed frame rect on screen
            let frameX      = w * frameLeftPct
            let frameW      = w * (frameRightPct - frameLeftPct)
            let frameY      = h * frameTopPct
            let frameH      = h * (frameBottomPct - frameTopPct)
            let frameCenterX = frameX + frameW / 2
            let frameCenterY = frameY + frameH / 2

            // Cat size: fill frame with a little inset
            let catSize = min(frameW, frameH) * 0.90

            ZStack {
                // Background illustration
                Image("amazing_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()
                    .ignoresSafeArea()

                // Cat image clipped inside the frame
                CatImageView(imageSource: imageSource)
                    .frame(width: catSize, height: catSize)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .position(x: frameCenterX, y: frameCenterY)
                    .scaleEffect(appear ? 1.0 : 0.75)
                    .opacity(appear ? 1 : 0)

                // Transparent button over the "Continue Playing" area (~87–93% of height)
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        gameState.showFullScreenCelebration = false
                        gameState.happiness = 0
                    }
                }) {
                    Color.clear
                        .frame(width: w * 0.70, height: h * 0.07)
                }
                .buttonStyle(ScalePressStyle())
                .position(x: w / 2, y: h * 0.915)

                // Ana Sayfaya Dön butonu
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        gameState.showFullScreenCelebration = false
                        gameState.resetGame()
                        gameState.currentScreen = .welcome
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Ana Sayfaya Dön")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 11)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(ScalePressStyle())
                .position(x: w / 2, y: h * 0.16)
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
            }
        }
    }
}
