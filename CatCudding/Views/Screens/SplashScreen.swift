import SwiftUI

struct SplashScreen: View {
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 1.06
    var onFinished: () -> Void

    var body: some View {
        GeometryReader { geo in
            Image("SplashImage")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
        .ignoresSafeArea()
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 1
                scale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeIn(duration: 0.45)) { opacity = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { onFinished() }
            }
        }
    }
}
