import SwiftUI

struct AccessoryShopView: View {
    @ObservedObject var gameState: GameState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Handle
            Capsule()
                .fill(Color.primary.opacity(0.2))
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            Text("Accessories")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 16)
                .padding(.bottom, 20)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(Accessory.all) { accessory in
                    let isEquipped = gameState.equippedAccessories.contains(accessory.id)
                    AccessoryCell(accessory: accessory, isEquipped: isEquipped) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            gameState.toggleAccessory(accessory)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(Color(uiColor: .systemBackground))
    }
}

private struct AccessoryCell: View {
    let accessory: Accessory
    let isEquipped: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                Image(accessory.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(16)
                    .frame(height: 130)
                    .frame(maxWidth: .infinity)
                    .background(isEquipped
                        ? LinearGradient(colors: [Color.appRose.opacity(0.15), Color.appCoral.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [Color.primary.opacity(0.04), Color.primary.opacity(0.02)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )

                HStack(spacing: 4) {
                    Text(accessory.category.emoji).font(.system(size: 12))
                    Text(accessory.name)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 8).padding(.vertical, 5)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isEquipped ? Color.appRose : Color.primary.opacity(0.1), lineWidth: isEquipped ? 2.5 : 1)
            )
            .overlay(alignment: .topTrailing) {
                if isEquipped {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.appRose)
                        .padding(8)
                }
            }
            .shadow(color: isEquipped ? Color.appRose.opacity(0.3) : Color.black.opacity(0.08), radius: isEquipped ? 8 : 3)
        }
        .buttonStyle(ScalePressStyle())
    }
}
