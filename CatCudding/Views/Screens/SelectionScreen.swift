import SwiftUI

struct SelectionScreen: View {
    @ObservedObject var gameState: GameState
    @State private var cardsVisible = false

    var body: some View {
        ZStack {
            AppBackground()
            AmbientGlow()

            VStack(spacing: 0) {
                HStack {
                    BackButton {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.currentScreen = .welcome
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20).padding(.top, 8)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Choose Your Cat")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Find your purrfect pal 🐾")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.55))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(Array(gameState.cats.enumerated()), id: \.element.id) { index, cat in
                            CatSelectionCard(
                                cat: cat,
                                imageSource: gameState.catImages[index],
                                isSelected: gameState.selectedCat?.id == cat.id
                            ) {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.65)) { gameState.selectCat(cat) }
                            }
                            .opacity(cardsVisible ? 1 : 0).offset(y: cardsVisible ? 0 : 22)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(Double(index) * 0.08), value: cardsVisible)
                        }

                        if let customCat = gameState.customCat {
                            CatSelectionCard(
                                cat: customCat,
                                imageSource: gameState.customCatImage,
                                isSelected: gameState.selectedCat?.id == customCat.id
                            ) {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.65)) { gameState.selectCat(customCat) }
                            }
                            .opacity(cardsVisible ? 1 : 0).offset(y: cardsVisible ? 0 : 22)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.24), value: cardsVisible)
                        }

                        AddCustomCatCard(gameState: gameState)
                            .opacity(cardsVisible ? 1 : 0).offset(y: cardsVisible ? 0 : 22)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.30), value: cardsVisible)
                    }
                    .padding(.horizontal, 20).padding(.bottom, 16)
                }

                PrimaryButton(title: "Let's Cuddle! 🐱", action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) { gameState.currentScreen = .game }
                }, isEnabled: gameState.selectedCat != nil)
                .padding(.horizontal, 20).padding(.bottom, 36)
                .opacity(cardsVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.35), value: cardsVisible)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation { cardsVisible = true }
            }
        }
    }
}
