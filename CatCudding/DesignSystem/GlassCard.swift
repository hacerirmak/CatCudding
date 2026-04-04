import SwiftUI

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.cardBorder(colorScheme), lineWidth: 1)
            )
    }
}
