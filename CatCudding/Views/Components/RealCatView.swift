import SwiftUI

struct RealCatView: View {
    let imageSource: Any?
    let size: CGFloat
    let isHappy: Bool
    let isIdle: Bool
    let isBeingPetted: Bool
    let isExcited: Bool
    let isZoomedIn: Bool
    var headAngle: Double = 0

    @State private var idleAnimation = false
    @State private var heartBeat = false
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        ZStack {
            if isHappy {
                Circle()
                    .fill(Color.appRose.opacity(heartBeat ? 0.22 : 0.10))
                    .frame(width: size * 1.3, height: size * 1.3)
                    .blur(radius: 22)
                    .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: heartBeat)
            }

            CatImageView(imageSource: imageSource)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: isHappy ? [.appRose, .appPurple] : [Color.white.opacity(0.15), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isHappy ? 3 : 1
                        )
                        .opacity(isHappy ? (heartBeat ? 1.0 : 0.45) : 1.0)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 16, x: 0, y: 8)
                .scaleEffect(isZoomedIn ? 1.38 : (isBeingPetted ? 1.07 : (idleAnimation ? 1.014 : 1.0)))
                .rotationEffect(.degrees(headAngle * 0.35 + (isBeingPetted ? 1.5 : 0) + (isExcited ? shakeOffset * 1.5 : 0)))
                .offset(x: isExcited ? shakeOffset : 0, y: isZoomedIn ? -35 : 0)
                .animation(.spring(response: 0.32, dampingFraction: 0.62), value: isBeingPetted)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: idleAnimation)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isZoomedIn)
                .animation(.interpolatingSpring(stiffness: 200, damping: 10), value: headAngle)

            if isHappy {
                HStack(spacing: 6) {
                    Text("😊").font(.title2)
                    Text("💖").font(.title3)
                }
                .scaleEffect(heartBeat ? 1.15 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: heartBeat)
                .offset(y: -size * 0.44)
            }
        }
        .onAppear {
            if isIdle { withAnimation { idleAnimation = true } }
            if isHappy { withAnimation { heartBeat = true } }
            if isExcited { startShake() }
        }
        .onChange(of: isHappy) { withAnimation { heartBeat = isHappy } }
        .onChange(of: isExcited) {
            if isExcited { startShake() } else { shakeOffset = 0 }
        }
    }

    private func startShake() {
        withAnimation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) { shakeOffset = 3 }
    }
}
