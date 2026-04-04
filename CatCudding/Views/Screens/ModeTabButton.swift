import SwiftUI

struct ModeTabButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(icon).font(.system(size: 22))
                Text(label)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? .white : .primary.opacity(0.42))
            }
            .frame(minWidth: 72, minHeight: 60)
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
