import SwiftUI

struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState

    @State private var appear = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Full-screen background illustration (contains all text/decorations)
                Image("amazing_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Cat image positioned inside the card frame in the illustration
                    CatImageView(imageSource: imageSource)
                        .frame(width: geo.size.width * 0.58, height: geo.size.width * 0.58)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .scaleEffect(appear ? 1.0 : 0.80)
                        .opacity(appear ? 1 : 0)
                        .offset(y: -geo.size.height * 0.06)

                    Spacer()

                    // Invisible tappable area over the "Continue Playing" button in the image
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.showFullScreenCelebration = false
                            gameState.happiness = 0
                        }
                    }) {
                        Color.clear
                            .frame(maxWidth: .infinity, minHeight: 54)
                    }
                    .buttonStyle(ScalePressStyle())
                    .padding(.horizontal, 36)
                    .padding(.bottom, 48)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
            }
        }
    }
}
