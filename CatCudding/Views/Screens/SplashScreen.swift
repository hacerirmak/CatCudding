import SwiftUI

struct SplashScreen: View {
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 1.06
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            // Background matches the sky color of the splash image
            Color(red: 0.67, green: 0.87, blue: 0.98)
                .ignoresSafeArea()

            Image("SplashImage")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 1
                scale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeIn(duration: 0.45)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                    onFinished()
                }
            }
        }
    }
}
