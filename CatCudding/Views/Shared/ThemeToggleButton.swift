import SwiftUI

struct ThemeToggleButton: View {
    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some View {
        Button(action: { isDarkMode.toggle() }) {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .frame(width: 42, height: 42)
                .modifier(GlassCard(cornerRadius: 13))
        }
        .buttonStyle(.plain)
    }
}
