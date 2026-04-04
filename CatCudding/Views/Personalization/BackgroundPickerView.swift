import SwiftUI

struct BackgroundPickerView: View {
    @ObservedObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Handle
            Capsule()
                .fill(Color.primary.opacity(0.2))
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            Text("Choose Background")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 16)
                .padding(.bottom, 20)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(GameBackground.all) { bg in
                    BackgroundCell(bg: bg, isSelected: gameState.selectedBackground.id == bg.id) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            gameState.selectedBackground = bg
                        }
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(Color(uiColor: .systemBackground))
    }
}

private struct BackgroundCell: View {
    let bg: GameBackground
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                if let name = bg.imageName {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 130)
                        .clipped()
                } else {
                    LinearGradient(
                        colors: [Color(red:0.06,green:0.04,blue:0.18), Color(red:0.20,green:0.06,blue:0.22)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(height: 130)
                    .overlay(Text("🌌").font(.system(size: 40)))
                }

                HStack(spacing: 4) {
                    Text(bg.emoji).font(.system(size: 13))
                    Text(bg.name)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8).padding(.vertical, 5)
                .background(Color.black.opacity(0.45))
                .clipShape(Capsule())
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Color.appRose : Color.clear, lineWidth: 3)
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.appRose)
                        .padding(8)
                }
            }
            .shadow(color: isSelected ? Color.appRose.opacity(0.4) : Color.black.opacity(0.15), radius: isSelected ? 10 : 4)
        }
        .buttonStyle(ScalePressStyle())
    }
}
