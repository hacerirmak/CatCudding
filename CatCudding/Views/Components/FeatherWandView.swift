import SwiftUI

struct FeatherWandView: View {
    let attachPoint: CGPoint
    let tipPoint: CGPoint
    let inReach: Bool
    @State private var featherSway: Double = 0

    var body: some View {
        ZStack {
            Canvas { ctx, _ in
                let sag: CGFloat = 18 + abs(tipPoint.x - attachPoint.x) * 0.12
                let control = CGPoint(
                    x: (attachPoint.x + tipPoint.x) / 2,
                    y: (attachPoint.y + tipPoint.y) / 2 + sag
                )
                var path = Path()
                path.move(to: attachPoint)
                path.addQuadCurve(to: tipPoint, control: control)
                ctx.stroke(path, with: .color(.white.opacity(0.55)),
                           style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
            }

            Capsule()
                .fill(LinearGradient(
                    colors: [Color(red: 0.65, green: 0.45, blue: 0.25), Color(red: 0.40, green: 0.26, blue: 0.12)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .frame(width: 7, height: 55)
                .rotationEffect(.degrees((tipPoint.x - attachPoint.x) * 0.12), anchor: .top)
                .position(x: attachPoint.x, y: attachPoint.y + 28)

            Text("🪶")
                .font(.system(size: 38))
                .rotationEffect(.degrees(-30 + (tipPoint.x - attachPoint.x) * 0.25 + featherSway))
                .scaleEffect(inReach ? 1.18 : 1.0)
                .shadow(color: inReach ? Color.appRose.opacity(0.7) : Color.white.opacity(0.3), radius: inReach ? 10 : 4)
                .animation(.spring(response: 0.35, dampingFraction: 0.6), value: inReach)
                .position(tipPoint)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                featherSway = 8
            }
        }
    }
}
