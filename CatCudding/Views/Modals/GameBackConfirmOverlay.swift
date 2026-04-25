import SwiftUI

struct GameBackConfirmOverlay: View {
    @ObservedObject var gameState: GameState

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            Color(red: 42/255, green: 31/255, blue: 26/255)
                .opacity(0.45)
                .ignoresSafeArea()

            VStack {
                Spacer()
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 50)

                        Text("Leave the cuddle session?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.ccInk)
                            .multilineTextAlignment(.center)

                        Text("Your progress will be lost — your streak and current happiness reset.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.ccInk2)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .padding(.horizontal, 4)

                        HStack(spacing: 10) {
                            ConfirmStatChip(
                                value: "+\(Int(gameState.happiness))%",
                                label: "happiness gained",
                                bg: .ccWarnBg
                            )
                            ConfirmStatChip(
                                value: "\(gameState.streak) 🔥",
                                label: "day streak at risk",
                                bg: .ccDangerBg
                            )
                        }
                        .padding(.top, 20)

                        VStack(spacing: 8) {
                            CCPeachButton(title: "Keep Cuddling") {
                                withAnimation(.spring(response: 0.35)) {
                                    gameState.showBackConfirm = false
                                }
                            }
                            Button("Leave & Lose Progress") {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                    gameState.confirmLeave()
                                }
                            }
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.ccInk3)
                            .frame(maxWidth: .infinity, minHeight: 56)
                        }
                        .padding(.top, 20)
                    }
                    .padding(24)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .shadow(
                        color: Color(red: 42/255, green: 31/255, blue: 26/255).opacity(0.28),
                        radius: 60, x: 0, y: 30
                    )
                    .padding(.top, 44)

                    // Worried cat peeking above the card
                    ZStack {
                        Circle()
                            .fill(Color.ccBg)
                            .frame(width: 88, height: 88)
                            .shadow(
                                color: Color(red: 42/255, green: 31/255, blue: 26/255).opacity(0.18),
                                radius: 20, x: 0, y: 8
                            )
                        Text("😿")
                            .font(.system(size: 52))
                    }
                }
                .padding(.horizontal, 24)
                Spacer()
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.97)))
    }
}

private struct ConfirmStatChip: View {
    let value: String
    let label: String
    let bg: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.ccInk)
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.ccInk3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(bg)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct CCPeachButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(Color.ccPeach)
                .clipShape(Capsule())
                .shadow(color: Color.ccPeachDeep, radius: 0, x: 0, y: 3)
        }
        .buttonStyle(ScalePressStyle())
    }
}
