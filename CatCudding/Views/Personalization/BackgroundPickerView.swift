import SwiftUI

struct BackgroundPickerView: View {
    @ObservedObject var gameState: GameState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.primary.opacity(0.2))
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 16)

            Text("Background")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.bottom, 16)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(GameBackground.all) { bg in
                    BackgroundCell(
                        background: bg,
                        isSelected: gameState.selectedBackground.id == bg.id
                    ) {
                        gameState.selectedBackground = bg
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(.ultraThinMaterial)
    }
}

private struct BackgroundCell: View {
    let background: GameBackground
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                if let name = background.imageName {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 90)
                        .clipped()
                } else {
                    AppBackground()
                        .frame(height: 90)
                }

                VStack {
                    Spacer()
                    HStack {
                        Text(background.emoji).font(.system(size: 13))
                        Text(background.name)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.45))
                    .clipShape(Capsule())
                    .padding(.bottom, 6)
                }

                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor, lineWidth: 2.5)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 22))
                        .padding(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
            }
            .frame(height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
