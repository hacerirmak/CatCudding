import SwiftUI

struct CatCuddleApp: View {
    @StateObject private var gameState = GameState()
    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some View {
        ZStack {
            switch gameState.currentScreen {
            case .welcome:
                WelcomeScreen(gameState: gameState)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.97)), removal: .opacity.combined(with: .scale(scale: 1.03))))
            case .selection:
                SelectionScreen(gameState: gameState)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)), removal: .opacity.combined(with: .move(edge: .leading))))
            case .game:
                GameScreen(gameState: gameState)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)), removal: .opacity.combined(with: .move(edge: .leading))))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: gameState.currentScreen)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    CatCuddleApp()
}
