import SwiftUI

struct BackgroundPickerView: View {
    @Binding var selected: BackgroundScene
    @Environment(\.colorScheme) var colorScheme

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.primary.opacity(0.2))
                .frame(width: 40, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 16)

            Text("Choose Background")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 14)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(BackgroundScene.allCases) { scene in
                        BackgroundThumbCell(scene: scene, isSelected: selected == scene) {
                            selected = scene
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 24)
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

private struct BackgroundThumbCell: View {
    let scene: BackgroundScene
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                Group {
                    if UIImage(named: scene.assetName) != nil {
                        Image(scene.assetName)
                            .resizable()
                            .scaledToFill()
                    } else {
                        scene.fallbackGradient
                    }
                }
                .frame(height: 120)
                .clipped()

                HStack(spacing: 5) {
                    Image(systemName: scene.icon)
                        .font(.system(size: 10, weight: .semibold))
                    Text(scene.label)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isSelected
                            ? AnyShapeStyle(LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing))
                            : AnyShapeStyle(Color.clear),
                        lineWidth: isSelected ? 2.5 : 0
                    )
            )
            .shadow(
                color: isSelected ? Color.appRose.opacity(0.3) : Color.black.opacity(0.10),
                radius: isSelected ? 8 : 4, x: 0, y: 2
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
