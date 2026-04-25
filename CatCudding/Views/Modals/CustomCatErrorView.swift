import SwiftUI
import UIKit

struct CustomCatErrorView: View {
    @ObservedObject var gameState: GameState
    let error: CustomCatUploadError

    private var config: ErrorConfig { ErrorConfig(error) }

    var body: some View {
        ZStack {
            Color.ccBg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { gameState.customCatError = nil }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.ccInk)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color(red: 42/255, green: 31/255, blue: 26/255).opacity(0.08), radius: 8, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Text("Add Your Cat")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.ccInk)
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Step indicator
                HStack(spacing: 6) {
                    StepDot(active: true)
                    StepDot(active: true)
                    StepDot(active: false)
                }
                .padding(.top, 12)

                // Photo preview / error frame
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.ccBgAlt)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.ccLineStrong, style: StrokeStyle(lineWidth: 2, dash: [8, 5]))
                        )

                    // Checker pattern background
                    Canvas { ctx, size in
                        let cell: CGFloat = 20
                        for row in 0...Int(size.height / cell) {
                            for col in 0...Int(size.width / cell) {
                                if (row + col) % 2 == 0 {
                                    let r = CGRect(x: CGFloat(col) * cell, y: CGFloat(row) * cell, width: cell, height: cell)
                                    ctx.fill(Path(r), with: .color(.white.opacity(0.4)))
                                }
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                    VStack(spacing: 16) {
                        // Error pill
                        HStack(spacing: 6) {
                            Text(config.pillIcon).font(.system(size: 13))
                            Text(config.pillLabel)
                                .font(.system(size: 12, weight: .bold))
                                .kerning(0.5)
                                .textCase(.uppercase)
                        }
                        .foregroundColor(.ccInk)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(config.pillBg)
                        .clipShape(Capsule())

                        // Mood cat emoji
                        Text(config.catEmoji)
                            .font(.system(size: 80))
                    }

                    // bg-removal stripe overlay
                    if error == .bgRemovalFailed {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(
                                LinearGradient(
                                    stops: (0..<8).flatMap { i -> [Gradient.Stop] in
                                        let t = Double(i) / 8.0
                                        return [
                                            .init(color: .clear, location: t),
                                            .init(color: Color.ccDanger.opacity(0.06), location: t + 0.06)
                                        ]
                                    },
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .allowsHitTesting(false)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 20)
                .padding(.top, 24)

                // Copy block
                VStack(spacing: 8) {
                    Text(config.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.ccInk)
                        .multilineTextAlignment(.center)

                    Text(config.body)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.ccInk2)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)

                    if let hint = config.hint {
                        HStack(spacing: 6) {
                            Text("💡").font(.system(size: 13))
                            Text(hint)
                                .font(.system(size: 12.5, weight: .semibold))
                                .foregroundColor(.ccInk2)
                        }
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Color.ccWarnBg)
                        .clipShape(Capsule())
                        .padding(.top, 6)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()

                // CTAs
                VStack(spacing: 8) {
                    CCPeachButton(title: config.primaryCTA) {
                        handlePrimary()
                    }
                    if let secondary = config.secondaryCTA {
                        Button(secondary) {
                            gameState.customCatError = nil
                        }
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.ccInk)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.ccLineStrong, lineWidth: 1.5))
                        .buttonStyle(ScalePressStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }

    private func handlePrimary() {
        switch error {
        case .bgRemovalFailed:
            gameState.useCustomCatPhotoAnyway()
        case .permissionDenied:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        case .loadFailed, .unsupported:
            gameState.customCatError = nil
        }
    }
}

private struct StepDot: View {
    let active: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 999)
            .fill(active ? Color.ccPeach : Color.ccLine)
            .frame(width: 22, height: 6)
    }
}

private struct ErrorConfig {
    let pillBg: Color
    let pillIcon: String
    let pillLabel: String
    let catEmoji: String
    let title: String
    let body: String
    let hint: String?
    let primaryCTA: String
    let secondaryCTA: String?

    init(_ error: CustomCatUploadError) {
        switch error {
        case .loadFailed:
            pillBg = .ccDangerBg; pillIcon = "⚠"; pillLabel = "Load failed"
            catEmoji = "😿"
            title = "Couldn't load that photo"
            body = "The image didn't load — usually a flaky connection or a too-big file. Give it another go?"
            hint = nil
            primaryCTA = "Try Again"; secondaryCTA = "Pick a Different Photo"
        case .bgRemovalFailed:
            pillBg = .ccWarnBg; pillIcon = "✂"; pillLabel = "Cutout failed"
            catEmoji = "😟"
            title = "We couldn't separate your cat"
            body = "Background removal didn't work this time. A clearer photo with a plain background usually helps."
            hint = "Tip: bright lighting and a plain wall work best."
            primaryCTA = "Use Photo Anyway"; secondaryCTA = "Pick a Different Photo"
        case .unsupported:
            pillBg = .ccDangerBg; pillIcon = "✕"; pillLabel = "Unsupported format"
            catEmoji = "🐱"
            title = "That format isn't supported"
            body = "We can only read JPG, PNG, HEIC, or WebP. Try saving your photo in one of those formats."
            hint = "Supported: JPG · PNG · HEIC · WebP (max 12 MB)"
            primaryCTA = "Pick a Different Photo"; secondaryCTA = nil
        case .permissionDenied:
            pillBg = .ccWarnBg; pillIcon = "🔒"; pillLabel = "Access required"
            catEmoji = "😿"
            title = "Photo access is off"
            body = "We need permission to read photos so you can use your own cat. You can turn it on in Settings."
            hint = nil
            primaryCTA = "Open Settings"; secondaryCTA = "Not Now"
        }
    }
}
