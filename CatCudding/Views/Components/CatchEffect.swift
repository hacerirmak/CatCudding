import SwiftUI

struct CatchEffect: View {
    @State private var burst = false

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Text(["🪶", "✨", "⭐", "🌟"][i % 4])
                    .font(.system(size: 20))
                    .offset(
                        x: burst ? cos(CGFloat(i) * .pi / 4) * 90 : 0,
                        y: burst ? sin(CGFloat(i) * .pi / 4) * 90 : 0
                    )
                    .opacity(burst ? 0 : 1)
                    .animation(.easeOut(duration: 0.55).delay(Double(i) * 0.04), value: burst)
            }
            Text("😸")
                .font(.system(size: 48))
                .scaleEffect(burst ? 0.5 : 1.25)
                .opacity(burst ? 0 : 1)
                .animation(.easeOut(duration: 0.5), value: burst)
        }
        .onAppear { withAnimation { burst = true } }
    }
}
