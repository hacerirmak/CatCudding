import SwiftUI

struct ModeSwitchConfirmSheet: View {
    @ObservedObject var gameState: GameState
    let targetMode: GameMode
    @State private var keepHappiness = true

    var body: some View {
        VStack(spacing: 0) {
            // Grabber
            RoundedRectangle(cornerRadius: 999)
                .fill(Color.ccLineStrong)
                .frame(width: 36, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 16)

            // Header row with curious cat
            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.ccWarnBg)
                        .frame(width: 56, height: 56)
                    Text("🐱")
                        .font(.system(size: 34))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Switch to \(targetMode.displayName)?")
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(.ccInk)
                    HStack(spacing: 4) {
                        Text("Mochi is at")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.ccInk3)
                        Text("\(Int(gameState.happiness))% happy")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.ccPeachDeep)
                        Text("right now")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.ccInk3)
                    }
                }
                Spacer()
            }

            Text("Each mode is its own activity. Carry happiness over, or start fresh — your streak is safe either way.")
                .font(.system(size: 14.5, weight: .medium))
                .foregroundColor(.ccInk2)
                .lineSpacing(3)
                .padding(.top, 12)
                .padding(.bottom, 16)

            // Radio cards
            VStack(spacing: 10) {
                ModeRadioCard(
                    selected: keepHappiness,
                    icon: "❤️",
                    iconBg: .ccDangerBg,
                    title: "Keep happiness (\(Int(gameState.happiness))%)",
                    subtitle: "Pick up where you left off",
                    isDefault: true
                ) { keepHappiness = true }

                ModeRadioCard(
                    selected: !keepHappiness,
                    icon: "↺",
                    iconBg: .ccSky,
                    title: "Reset to 0%",
                    subtitle: "Start the new mode fresh",
                    isDefault: false
                ) { keepHappiness = false }
            }

            // CTAs
            VStack(spacing: 8) {
                CCPeachButton(title: "Switch to \(targetMode.displayName)") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        gameState.confirmModeSwitch(keepHappiness: keepHappiness)
                    }
                }
                Button("Cancel") {
                    withAnimation { gameState.cancelModeSwitch() }
                }
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.ccInk3)
                .frame(maxWidth: .infinity, minHeight: 56)
            }
            .padding(.top, 18)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

private struct ModeRadioCard: View {
    let selected: Bool
    let icon: String
    let iconBg: Color
    let title: String
    let subtitle: String
    let isDefault: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(iconBg)
                        .frame(width: 40, height: 40)
                    Text(icon)
                        .font(.system(size: 18))
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.ccInk)
                        if isDefault {
                            Text("DEFAULT")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.ccDanger)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color.ccDangerBg)
                                .clipShape(Capsule())
                        }
                    }
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.ccInk3)
                }

                Spacer()

                // Radio dot
                ZStack {
                    Circle()
                        .fill(selected ? Color.ccPeach : Color.white)
                        .frame(width: 22, height: 22)
                    if !selected {
                        Circle()
                            .stroke(Color.ccLineStrong, lineWidth: 2)
                            .frame(width: 22, height: 22)
                    }
                    if selected {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(14)
            .background(selected ? Color.ccBg : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        selected ? Color.ccPeach : Color.ccLine,
                        lineWidth: selected ? 2.5 : 1.5
                    )
            )
            .shadow(
                color: Color(red: 42/255, green: 31/255, blue: 26/255).opacity(selected ? 0.06 : 0.03),
                radius: 8, x: 0, y: 4
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.28), value: selected)
    }
}
