import Foundation
import CoreGraphics

struct FloatingElement: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    var opacity: Double = 1.0
}
