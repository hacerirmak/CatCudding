import SwiftUI

struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState

    @State private var appear = false
    @State private var pulse = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Full-screen background illustration
                Image("amazing_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Title
                    Text("🎉 Amazing! 🎉")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(Color(red: 0.42, green: 0.18, blue: 0.72))
                        .shadow(color: .white.opacity(0.6), radius: 4, x: 0, y: 1)
                        .scaleEffect(pulse ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: pulse)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 20)
                        .padding(.top, 52)

                    // Subtitle
                    Text("\(catName) is super happy!")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.15, green: 0.62, blue: 0.58))
                        .shadow(color: .white.opacity(0.5), radius: 3, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 14)
                        .padding(.top, 6)

                    Spacer()

                    // Cat image inside the card frame area
                    CatImageView(imageSource: imageSource)
                        .frame(width: geo.size.width * 0.58, height: geo.size.width * 0.58)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .scaleEffect(appear ? 1.0 : 0.80)
                        .opacity(appear ? 1 : 0)
                        // Position roughly centered in the card frame in the illustration
                        .offset(y: -geo.size.height * 0.04)

                    Spacer()

                    // Subtitle below card
                    Text("You've made \(catName) the happiest cat ever!")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.38, green: 0.15, blue: 0.60))
                        .shadow(color: .white.opacity(0.6), radius: 3, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 10)

                    // Continue Playing button
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.showFullScreenCelebration = false
                            gameState.happiness = 0
                        }
                    }) {
                        Text("Continue Playing")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.32, green: 0.16, blue: 0.02))
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.85, blue: 0.35), Color(red: 0.95, green: 0.70, blue: 0.15)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color(red: 0.80, green: 0.55, blue: 0.10), lineWidth: 2))
                            .shadow(color: Color(red: 0.90, green: 0.65, blue: 0.10).opacity(0.5), radius: 10, x: 0, y: 4)
                    }
                    .buttonStyle(ScalePressStyle())
                    .padding(.horizontal, 36)
                    .padding(.top, 16)
                    .padding(.bottom, 48)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 16)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
                withAnimation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true).delay(0.6)) { pulse = true }
            }
        }
    }
}
