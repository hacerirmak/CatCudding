import SwiftUI

struct AccessoryShopView: View {
    @ObservedObject var gameState: GameState
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.primary.opacity(0.2))
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 16)

            Text("Accessories")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.bottom, 16)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Accessory.all) { acc in
                    AccessoryCell(
                        accessory: acc,
                        isEquipped: gameState.equippedAccessories.contains(acc.id)
                    ) {
                        gameState.toggleAccessory(acc)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(.ultraThinMaterial)
    }
}

private struct AccessoryCell: View {
    let accessory: Accessory
    let isEquipped: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isEquipped ? Color.accentColor.opacity(0.15) : Color.primary.opacity(0.06))

                VStack(spacing: 8) {
                    Image(accessory.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 72)

                    Text(accessory.name)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 12)

                if isEquipped {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor, lineWidth: 2)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 20))
                        .padding(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
            }
            .frame(height: 110)
        }
        .buttonStyle(.plain)
    }
}
