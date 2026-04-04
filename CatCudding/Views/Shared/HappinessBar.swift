import SwiftUI

struct HappinessBar: View {
    let value: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 8)
                Capsule()
                    .fill(LinearGradient(
                        colors: value > 70 ? [Color.green.opacity(0.9), Color.mint] : [.appRose, .appCoral],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: geo.size.width * CGFloat(value / 100), height: 8)
                    .shadow(color: Color.appRose.opacity(0.5), radius: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: value)
            }
        }.frame(height: 8)
    }
}
