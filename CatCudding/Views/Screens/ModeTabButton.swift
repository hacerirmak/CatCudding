import SwiftUI

struct ModeTabButton: View {
    let imageName: String
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                Text(label)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? .white : .primary.opacity(0.42))
            }
            .frame(minWidth: 80, minHeight: 72)
            .background {
                if isActive {
                    LinearGradient(
                        colors: [Color.appRose.opacity(0.55), Color.appCoral.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(Capsule())
                }
            }
        }
        .buttonStyle(ScalePressStyle())
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isActive)
    }
}
