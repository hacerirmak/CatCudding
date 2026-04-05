import CoreGraphics

enum AccessoryCategory: String {
    case head, neck, wings, special
}

struct Accessory: Identifiable, Equatable {
    let id: String
    let name: String
    let category: AccessoryCategory
    let imageName: String
    var offsetX: CGFloat
    var offsetY: CGFloat
    var scale: CGFloat

    static let all: [Accessory] = [
        Accessory(id: "head",    name: "Baş",      category: .head,    imageName: "acc_head",    offsetX: 0, offsetY: -0.58, scale: 0.72),
        Accessory(id: "neck",    name: "Boyun",    category: .neck,    imageName: "acc_neck",    offsetX: 0, offsetY:  0.30, scale: 0.55),
        Accessory(id: "wings",   name: "Kanatlar", category: .wings,   imageName: "acc_wings",   offsetX: 0, offsetY:  0.10, scale: 1.10),
        Accessory(id: "special", name: "Özel",     category: .special, imageName: "acc_special", offsetX: 0, offsetY: -0.72, scale: 0.80),
    ]
}
