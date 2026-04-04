import SwiftUI

struct CatSelectionCard: View {
    let cat: Cat
    let imageSource: Any?
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isSelected
                            ? LinearGradient(colors: [.appRose, .appCoral], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.white.opacity(0.10), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 58, height: 58)
                    Group {
                        if let name = imageSource as? String {
                            Image(name).resizable().aspectRatio(contentMode: .fill).frame(width: 48, height: 48).clipShape(Circle())
                        } else if let img = imageSource as? UIImage {
                            Image(uiImage: img).resizable().aspectRatio(contentMode: .fill).frame(width: 48, height: 48).clipShape(Circle())
                        } else {
                            Text(cat.emoji).font(.system(size: 26))
                        }
                    }
                }
                .overlay(Circle().stroke(isSelected ? Color.clear : Color.white.opacity(0.15), lineWidth: 1.5))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(cat.name)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        if cat.isCustom {
                            Text("CUSTOM")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(.appPurple)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.appPurple.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    Text(cat.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(isSelected
                            ? LinearGradient(colors: [Color(red: 0.22, green: 0.78, blue: 0.44), .mint], startPoint: .top, endPoint: .bottom)
                            : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 28, height: 28)
                    if isSelected {
                        Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                    }
                }
                .overlay(Circle().stroke(Color.white.opacity(isSelected ? 0 : 0.12), lineWidth: 1))
            }
            .padding(16)
            .background {
                if isSelected {
                    LinearGradient(colors: [Color.appRose.opacity(0.14), Color.appCoral.opacity(0.07)], startPoint: .leading, endPoint: .trailing)
                } else {
                    Color.white.opacity(0.07)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        isSelected
                            ? LinearGradient(colors: [Color.appRose.opacity(0.8), Color.appCoral.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .shadow(color: isSelected ? Color.appRose.opacity(0.2) : .clear, radius: 12, x: 0, y: 4)
            .scaleEffect(isSelected ? 1.01 : 1.0)
        }
        .buttonStyle(ScalePressStyle())
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
}
