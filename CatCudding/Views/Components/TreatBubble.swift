import SwiftUI

struct TreatBubble: View {
    let treat: DraggableTreat
    let catCenter: CGPoint

    private var distToCat: CGFloat {
        hypot(treat.position.x - catCenter.x, treat.position.y - catCenter.y)
    }
    private var isNearCat: Bool { distToCat < 120 }

    var body: some View {
        ZStack {
            Circle()
                .fill(isNearCat
                    ? LinearGradient(colors: [treat.type.glowColor.opacity(0.35), treat.type.glowColor.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    : LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 70, height: 70)
                .overlay(Circle().stroke(isNearCat ? treat.type.glowColor.opacity(0.8) : Color.white.opacity(0.2), lineWidth: isNearCat ? 2 : 1.5))
                .shadow(color: isNearCat ? treat.type.glowColor.opacity(0.5) : .clear, radius: 12)
            Text(treat.type.emoji).font(.system(size: 36))
        }
        .scaleEffect(treat.isDragging ? 1.3 : 1.0)
        .shadow(color: treat.isDragging ? Color.black.opacity(0.3) : .clear, radius: 16, x: 0, y: 8)
        .animation(.spring(response: 0.25, dampingFraction: 0.62), value: treat.isDragging)
        .animation(.spring(response: 0.2), value: isNearCat)
    }
}
