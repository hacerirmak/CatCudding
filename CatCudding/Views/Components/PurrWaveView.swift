import SwiftUI

struct PurrWaveView: View {
    let intensity: Double
    @State private var animating = false

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { ring in
                let strokeOpacity = max(0, intensity * 0.22 - Double(ring) * 0.05)
                let scaleActive: CGFloat = 1.0 + CGFloat(ring + 1) * 0.4
                let scaleIdle: CGFloat = 1.0 + CGFloat(ring) * 0.1
                Circle()
                    .stroke(Color.appRose.opacity(strokeOpacity), lineWidth: 1.5)
                    .scaleEffect(animating ? scaleActive : scaleIdle)
                    .opacity(animating ? 0 : 0.8)
                    .animation(.easeOut(duration: 2.0).repeatForever(autoreverses: false).delay(Double(ring) * 0.55), value: animating)
            }
        }
        .frame(width: 270, height: 270)
        .onAppear { animating = true }
    }
}
