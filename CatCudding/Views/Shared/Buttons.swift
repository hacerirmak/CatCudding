import SwiftUI

struct ScalePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 58)
                .background(
                    isEnabled
                        ? LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .shadow(color: isEnabled ? Color.appRose.opacity(0.4) : .clear, radius: 12, x: 0, y: 6)
        }
        .disabled(!isEnabled)
        .buttonStyle(ScalePressStyle())
    }
}

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 42, height: 42)
                .modifier(GlassCard(cornerRadius: 13))
        }.buttonStyle(.plain)
    }
}
