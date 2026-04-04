import SwiftUI
import AVFoundation
import Combine
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

// MARK: - Design Tokens
extension Color {
    static let appRose   = Color(red: 1.00, green: 0.38, blue: 0.52)
    static let appCoral  = Color(red: 1.00, green: 0.58, blue: 0.28)
    static let appPurple = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let appBlue   = Color(red: 0.35, green: 0.55, blue: 0.98)
}

// MARK: - Shared Backgrounds
struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(red:0.06,green:0.04,blue:0.18), Color(red:0.14,green:0.05,blue:0.28), Color(red:0.20,green:0.06,blue:0.22)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }
}

struct AmbientGlow: View {
    var body: some View {
        ZStack {
            Circle().fill(Color.appPurple.opacity(0.14)).frame(width:300,height:300).blur(radius:70).offset(x:120,y:-180)
            Circle().fill(Color.appRose.opacity(0.10)).frame(width:250,height:250).blur(radius:60).offset(x:-100,y:200)
        }.allowsHitTesting(false)
    }
}

// MARK: - Shared Components
struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1))
    }
}

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
                .background(isEnabled
                    ? LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
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

struct HappinessBar: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.12)).frame(height: 8)
                Capsule()
                    .fill(LinearGradient(
                        colors: value > 70 ? [Color.green.opacity(0.9), Color.mint] : [.appRose, .appCoral],
                        startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * CGFloat(value / 100), height: 8)
                    .shadow(color: Color.appRose.opacity(0.5), radius: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: value)
            }
        }.frame(height: 8)
    }
}

struct CatImageView: View {
    let imageSource: Any?
    var body: some View {
        Group {
            if let name = imageSource as? String {
                Image(name).resizable().aspectRatio(contentMode: .fit)
            } else if let img = imageSource as? UIImage {
                Image(uiImage: img).resizable().aspectRatio(contentMode: .fit)
            } else {
                Color.clear.overlay(Text("🐱").font(.system(size: 80)))
            }
        }
    }
}

// MARK: - Celebration View
struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState
    @State private var floatHearts: [FloatingElement] = []
    @State private var floatSparkles: [FloatingElement] = []
    @State private var appear = false
    @State private var pulse = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [Color(red:0.10,green:0.03,blue:0.22), Color(red:0.25,green:0.05,blue:0.35), Color(red:0.35,green:0.08,blue:0.25)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ).ignoresSafeArea()
                Circle().fill(Color.appRose.opacity(0.15)).frame(width:300,height:300).blur(radius:60).offset(x:-80,y:-200)
                Circle().fill(Color.appPurple.opacity(0.12)).frame(width:250,height:250).blur(radius:50).offset(x:100,y:200)

                ForEach(floatHearts) { h in Text("🐾").font(.system(size:22)).position(x:h.x,y:h.y).opacity(h.opacity) }
                ForEach(floatSparkles) { s in Text("✨").font(.system(size:18)).position(x:s.x,y:s.y).opacity(s.opacity) }

                VStack(spacing: 28) {
                    Text("🎉 Amazing! 🎉")
                        .font(.system(size: 32, weight: .black, design: .rounded)).foregroundColor(.white)
                        .scaleEffect(pulse ? 1.06 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                        .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 20).padding(.top, 60)

                    Text("\(catName) is super happy!")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85)).multilineTextAlignment(.center)
                        .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 15)

                    CatImageView(imageSource: imageSource)
                        .frame(maxWidth: geo.size.width * 0.72, maxHeight: geo.size.height * 0.42)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(LinearGradient(colors: [.appRose, .appPurple], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3))
                        .shadow(color: Color.appRose.opacity(0.35), radius: 24, x: 0, y: 8)
                        .scaleEffect(appear ? 1.0 : 0.7).opacity(appear ? 1 : 0)

                    VStack(spacing: 8) {
                        Text("💖 Perfect Happiness Achieved! 💖")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white).multilineTextAlignment(.center)
                        Text("You've made \(catName) the happiest cat ever!")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.7)).multilineTextAlignment(.center)
                    }.opacity(appear ? 1 : 0).offset(y: appear ? 0 : 10)

                    Spacer()

                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.showFullScreenCelebration = false
                            gameState.happiness = 0
                        }
                    }) {
                        Text("Continue Playing")
                            .font(.system(size: 17, weight: .bold, design: .rounded)).foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                            .shadow(color: Color.appRose.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .buttonStyle(ScalePressStyle())
                    .padding(.horizontal, 32).padding(.bottom, 44)
                    .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 20)
                }
                .padding(.horizontal, 24)
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.5)) { pulse = true }
                generateEffects(in: geo.size)
            }
        }
    }

    private func generateEffects(in size: CGSize) {
        for i in 0..<18 {
            let h = FloatingElement(x: .random(in:0...size.width), y: .random(in:0...size.height))
            floatHearts.append(h)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.12) {
                withAnimation(.easeOut(duration: 3.0)) {
                    if let idx = floatHearts.firstIndex(where: {$0.id == h.id}) {
                        floatHearts[idx] = FloatingElement(x: h.x + .random(in:-80...80), y: h.y - 220, opacity: 0)
                    }
                }
            }
        }
        for i in 0..<25 {
            let s = FloatingElement(x: .random(in:0...size.width), y: .random(in:0...size.height))
            floatSparkles.append(s)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    if let idx = floatSparkles.firstIndex(where: {$0.id == s.id}) {
                        floatSparkles[idx] = FloatingElement(x: s.x + .random(in:-120...120), y: s.y - 130, opacity: 0)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { floatHearts.removeAll(); floatSparkles.removeAll() }
    }
}

// MARK: - Models
struct Cat: Identifiable, Equatable {
    let id = UUID()
    let name: String; let description: String; let breed: String
    let color: Color; let emoji: String; let isCustom: Bool
    init(name: String, description: String, breed: String, color: Color, emoji: String, isCustom: Bool = false) {
        self.name = name; self.description = description; self.breed = breed
        self.color = color; self.emoji = emoji; self.isCustom = isCustom
    }
    static func == (lhs: Cat, rhs: Cat) -> Bool { lhs.id == rhs.id }
}

struct FloatingElement: Identifiable {
    let id = UUID(); let x: CGFloat; let y: CGFloat; var opacity: Double = 1.0
}

enum TreatType: CaseIterable {
    case fish, meat, shrimp
    var emoji: String { switch self { case .fish: "🐟"; case .meat: "🍖"; case .shrimp: "🦐" } }
    var happinessValue: Double { switch self { case .fish: 15; case .meat: 25; case .shrimp: 20 } }
    var glowColor: Color { switch self { case .fish: Color.cyan; case .meat: Color.red; case .shrimp: Color.orange } }
}

struct DraggableTreat: Identifiable {
    let id = UUID(); let type: TreatType
    var position: CGPoint; let startPosition: CGPoint
    var isEaten = false; var opacity: Double = 1.0
    var scale: CGFloat = 1.0; var isDragging = false
}

// MARK: - Game State
class GameState: ObservableObject {
    @Published var currentScreen: ScreenType = .welcome
    @Published var selectedCat: Cat?
    @Published var happiness: Double = 0
    @Published var hearts: [FloatingElement] = []
    @Published var sparkles: [FloatingElement] = []
    @Published var isBeingPetted = false
    @Published var showFullScreenCelebration = false
    @Published var customCatImage: UIImage?
    @Published var customCatName = ""
    @Published var currentMode: GameMode = .cuddle

    // Cuddle
    @Published var petDragLocation: CGPoint? = nil
    @Published var purrIntensity: Double = 0

    // Treats
    @Published var draggableTreats: [DraggableTreat] = []
    @Published var showFeedingComplete = false

    // Toys
    @Published var laserPosition: CGPoint? = nil
    @Published var catIsExcited = false
    @Published var catZoomedIn = false
    @Published var showPounceEffect = false

    let cats = [
        Cat(name: "Whiskers",      description: "Super playful!",       breed: "Orange Tabby",     color: .orange, emoji: "🧡"),
        Cat(name: "Cloudy Paws",   description: "Gentle giant",         breed: "British Shorthair", color: .gray,   emoji: "🩶"),
        Cat(name: "Shadow Pounce", description: "Mischievous explorer", breed: "Black Kitten",      color: .black,  emoji: "🖤")
    ]
    let catImages = ["cat1", "cat2", "cat3"]

    var customCat: Cat? {
        guard customCatImage != nil, !customCatName.isEmpty else { return nil }
        return Cat(name: customCatName.isEmpty ? "My Cat" : customCatName,
                   description: "My special friend!", breed: "Custom Cat",
                   color: .purple, emoji: "💜", isCustom: true)
    }

    private var purrDecay: AnyCancellable?
    private var lastPetTime: Date = .distantPast
    private var pounceWork: DispatchWorkItem?

    // MARK: Cat
    func selectCat(_ cat: Cat) { selectedCat = cat }

    func getImageForCat(_ cat: Cat) -> Any? {
        if cat.isCustom { return customCatImage }
        if let i = cats.firstIndex(of: cat) { return catImages[i] }
        return nil
    }

    func addCustomCat(image: UIImage, name: String) {
        removeBackground(from: image) { processed in
            DispatchQueue.main.async {
                self.customCatImage = processed ?? image
                self.customCatName = name.isEmpty ? "My Cat" : name
            }
        }
    }

    // MARK: Cuddle
    func startPetting(at location: CGPoint) {
        isBeingPetted = true
        petDragLocation = location
        purrDecay?.cancel()
        purrIntensity = min(purrIntensity + 0.06, 1.0)
        generateSparkleAt(location)

        let now = Date()
        guard now.timeIntervalSince(lastPetTime) > 0.3 else { return }
        lastPetTime = now
        withAnimation(.easeInOut(duration: 0.2)) { happiness = min(happiness + 5, 100) }
        generateHearts(at: location)
        AudioServicesPlaySystemSound(1104)
        if happiness >= 95 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { self.showFullScreenCelebration = true }
            }
        }
    }

    func stopPetting() {
        isBeingPetted = false
        petDragLocation = nil
        purrDecay = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.purrIntensity > 0 { self.purrIntensity = max(0, self.purrIntensity - 0.025) }
                else { self.purrDecay?.cancel() }
            }
    }

    // MARK: Treats
    func setupTreats(in size: CGSize) {
        guard draggableTreats.isEmpty else { return }
        let types: [TreatType] = [.fish, .meat, .shrimp, .fish, .shrimp]
        let bottomY = size.height - 80
        let spacing = size.width / CGFloat(types.count + 1)
        draggableTreats = types.enumerated().map { i, type in
            let pos = CGPoint(x: spacing * CGFloat(i + 1), y: bottomY)
            return DraggableTreat(type: type, position: pos, startPosition: pos)
        }
    }

    func dragTreat(_ id: UUID, to location: CGPoint) {
        guard let i = draggableTreats.firstIndex(where: { $0.id == id }) else { return }
        draggableTreats[i].position = location
        draggableTreats[i].isDragging = true
    }

    func dropTreat(_ id: UUID, catCenter: CGPoint) {
        guard let i = draggableTreats.firstIndex(where: { $0.id == id && !$0.isEaten }) else { return }
        let dist = hypot(draggableTreats[i].position.x - catCenter.x, draggableTreats[i].position.y - catCenter.y)
        if dist < 120 {
            eatTreat(at: i)
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                draggableTreats[i].position = draggableTreats[i].startPosition
                draggableTreats[i].isDragging = false
            }
        }
    }

    private func eatTreat(at i: Int) {
        let value = draggableTreats[i].type.happinessValue
        AudioServicesPlaySystemSound(1103)
        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
            draggableTreats[i].isEaten = true; draggableTreats[i].scale = 1.7
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.3)) {
                guard i < self.draggableTreats.count else { return }
                self.draggableTreats[i].opacity = 0; self.draggableTreats[i].scale = 0.1
            }
        }
        withAnimation(.easeInOut(duration: 0.35)) { happiness = min(happiness + value, 100) }
        if happiness + value >= 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { self.showFullScreenCelebration = true }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if self.draggableTreats.allSatisfy({ $0.isEaten }) {
                withAnimation { self.showFeedingComplete = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation { self.showFeedingComplete = false }
                }
            }
        }
    }

    // MARK: Toys
    func moveLaser(to location: CGPoint) {
        laserPosition = location
        catIsExcited = true
        pounceWork?.cancel()
        let work = DispatchWorkItem { [weak self] in self?.pounce() }
        pounceWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: work)
    }

    func endLaser() {
        catIsExcited = false
        pounceWork?.cancel()
        withAnimation(.easeOut(duration: 0.5)) { laserPosition = nil }
    }

    private func pounce() {
        guard currentMode == .toys else { return }
        AudioServicesPlaySystemSound(1105)
        showPounceEffect = true
        withAnimation(.spring(response: 0.22, dampingFraction: 0.45)) { catZoomedIn = true }
        withAnimation(.easeInOut(duration: 0.3)) { happiness = min(happiness + 20, 100) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.laserPosition = nil
            withAnimation(.spring(response: 0.55, dampingFraction: 0.7)) { self.catZoomedIn = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            withAnimation { self.showPounceEffect = false }
            self.catIsExcited = false
            if self.happiness >= 100 {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { self.showFullScreenCelebration = true }
            }
        }
    }

    // MARK: Mode / Reset
    func switchMode(to newMode: GameMode) {
        guard newMode != currentMode else { return }
        cleanupCurrentMode()
        withAnimation(.easeOut(duration: 0.3)) { happiness = 0 }
        showFullScreenCelebration = false
        currentMode = newMode
    }

    private func cleanupCurrentMode() {
        hearts.removeAll(); sparkles.removeAll()
        isBeingPetted = false; petDragLocation = nil
        purrIntensity = 0; purrDecay?.cancel()
        draggableTreats.removeAll(); showFeedingComplete = false
        laserPosition = nil; catIsExcited = false; catZoomedIn = false; showPounceEffect = false
        pounceWork?.cancel()
    }

    func resetGame() { happiness = 0; showFullScreenCelebration = false; cleanupCurrentMode(); currentMode = .cuddle }

    // MARK: Particles
    func generateHearts(at location: CGPoint) {
        let batch = (0..<3).map { _ in
            FloatingElement(x: location.x + .random(in:-40...40), y: location.y + .random(in:-20...20))
        }
        hearts.append(contentsOf: batch)
        for (i, h) in batch.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                withAnimation(.easeOut(duration: 1.8)) {
                    if let idx = self.hearts.firstIndex(where: {$0.id == h.id}) {
                        self.hearts[idx] = FloatingElement(x: h.x + .random(in:-30...30), y: h.y - 90, opacity: 0)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.hearts.removeAll { h in batch.contains { $0.id == h.id } }
        }
    }

    func generateSparkleAt(_ location: CGPoint) {
        guard Bool.random() else { return }
        let s = FloatingElement(x: location.x + .random(in:-25...25), y: location.y + .random(in:-25...25))
        sparkles.append(s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
            withAnimation(.easeInOut(duration: 0.9)) {
                if let idx = self.sparkles.firstIndex(where: {$0.id == s.id}) {
                    self.sparkles[idx] = FloatingElement(x: s.x + .random(in:-40...40), y: s.y - 55, opacity: 0)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { self.sparkles.removeAll { $0.id == s.id } }
    }

    // MARK: Vision
    private func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        let fixed = fixImageOrientation(image)
        guard let ci = CIImage(image: fixed) else { completion(nil); return }
        let request = VNGenerateForegroundInstanceMaskRequest { req, err in
            guard err == nil, let results = req.results as? [VNInstanceMaskObservation], let result = results.first else { completion(nil); return }
            do {
                let mask = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: VNImageRequestHandler(ciImage: ci))
                let filter = CIFilter.blendWithMask()
                filter.inputImage = ci; filter.backgroundImage = CIImage.empty(); filter.maskImage = CIImage(cvPixelBuffer: mask)
                if let out = filter.outputImage, let cg = CIContext().createCGImage(out, from: out.extent) {
                    completion(UIImage(cgImage: cg, scale: fixed.scale, orientation: .up))
                } else { completion(nil) }
            } catch { completion(nil) }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            try? VNImageRequestHandler(ciImage: ci, options: [:]).perform([request])
        }
    }

    private func fixImageOrientation(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up { return image }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let fixed = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return fixed ?? image
    }
}

enum ScreenType { case welcome, selection, game }
enum GameMode { case cuddle, treats, toys }

// MARK: - Game Mode Views

struct PurrWaveView: View {
    let intensity: Double
    @State private var animating = false
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { ring in
                Circle()
                    .stroke(Color.appRose.opacity(max(0, intensity * 0.22 - Double(ring) * 0.05)), lineWidth: 1.5)
                    .scaleEffect(animating ? 1.0 + CGFloat(ring + 1) * 0.4 : 1.0 + CGFloat(ring) * 0.1)
                    .opacity(animating ? 0 : 0.8)
                    .animation(.easeOut(duration: 2.0).repeatForever(autoreverses: false).delay(Double(ring) * 0.55), value: animating)
            }
        }
        .frame(width: 270, height: 270)
        .onAppear { animating = true }
    }
}

struct LaserDotView: View {
    @State private var pulse = false
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red.opacity(0.15))
                .frame(width: 48, height: 48)
                .scaleEffect(pulse ? 2.8 : 1.0)
                .opacity(pulse ? 0 : 0.6)
                .animation(.easeOut(duration: 0.65).repeatForever(autoreverses: false), value: pulse)
            Circle()
                .fill(RadialGradient(colors: [.white, .red], center: .center, startRadius: 0, endRadius: 7))
                .frame(width: 14, height: 14)
                .shadow(color: .red.opacity(0.9), radius: 10)
                .shadow(color: .red.opacity(0.4), radius: 22)
        }
        .onAppear { pulse = true }
    }
}

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

struct PounceEffect: View {
    @State private var burst = false
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Text("⭐").font(.system(size: 18))
                    .offset(x: burst ? cos(CGFloat(i) * .pi / 4) * 80 : 0,
                            y: burst ? sin(CGFloat(i) * .pi / 4) * 80 : 0)
                    .opacity(burst ? 0 : 1)
                    .animation(.easeOut(duration: 0.6).delay(Double(i) * 0.04), value: burst)
            }
            Text("😼").font(.system(size: 44))
                .scaleEffect(burst ? 0.6 : 1.2)
                .opacity(burst ? 0 : 1)
                .animation(.easeOut(duration: 0.5), value: burst)
        }
        .onAppear { withAnimation { burst = true } }
    }
}

// MARK: - Real Cat View
struct RealCatView: View {
    let imageSource: Any?
    let size: CGFloat
    let isHappy: Bool
    let isIdle: Bool
    let isBeingPetted: Bool
    let isExcited: Bool
    let isZoomedIn: Bool
    var headAngle: Double = 0

    @State private var idleAnimation = false
    @State private var heartBeat = false
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        ZStack {
            if isHappy {
                Circle()
                    .fill(Color.appRose.opacity(heartBeat ? 0.22 : 0.10))
                    .frame(width: size * 1.3, height: size * 1.3)
                    .blur(radius: 22)
                    .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: heartBeat)
            }
            CatImageView(imageSource: imageSource)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: isHappy ? [.appRose, .appPurple] : [Color.white.opacity(0.15), Color.white.opacity(0.05)],
                                startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: isHappy ? 3 : 1)
                        .opacity(isHappy ? (heartBeat ? 1.0 : 0.45) : 1.0)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 16, x: 0, y: 8)
                .scaleEffect(isZoomedIn ? 1.38 : (isBeingPetted ? 1.07 : (idleAnimation ? 1.014 : 1.0)))
                .rotationEffect(.degrees(headAngle * 0.35 + (isBeingPetted ? 1.5 : 0) + (isExcited ? shakeOffset * 1.5 : 0)))
                .offset(x: isExcited ? shakeOffset : 0, y: isZoomedIn ? -35 : 0)
                .animation(.spring(response: 0.32, dampingFraction: 0.62), value: isBeingPetted)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: idleAnimation)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isZoomedIn)
                .animation(.interpolatingSpring(stiffness: 200, damping: 10), value: headAngle)

            if isHappy {
                HStack(spacing: 6) { Text("😊").font(.title2); Text("💖").font(.title3) }
                    .scaleEffect(heartBeat ? 1.15 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: heartBeat)
                    .offset(y: -size * 0.44)
            }
        }
        .onAppear {
            if isIdle { withAnimation { idleAnimation = true } }
            if isHappy { withAnimation { heartBeat = true } }
            if isExcited { startShake() }
        }
        .onChange(of: isHappy) { withAnimation { heartBeat = isHappy } }
        .onChange(of: isExcited) {
            if isExcited { startShake() } else { shakeOffset = 0 }
        }
    }
    private func startShake() {
        withAnimation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) { shakeOffset = 3 }
    }
}

// MARK: - Welcome Screen
struct WelcomeScreen: View {
    @ObservedObject var gameState: GameState
    @State private var logoFloat: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 28
    @State private var pawOpacity: Double = 0
    @State private var pawDrift: [CGSize] = (0..<6).map { _ in CGSize(width: CGFloat.random(in:-10...10), height: CGFloat.random(in:0...15)) }

    private let pawSeeds: [(CGFloat, CGFloat, Double)] = [
        (0.14,0.11,-14),(0.83,0.09,18),(0.08,0.54,9),(0.88,0.47,-7),(0.21,0.82,24),(0.76,0.77,-18)
    ]

    var body: some View {
        ZStack {
            AppBackground()
            AmbientGlow()

            GeometryReader { geo in
                ForEach(0..<pawSeeds.count, id: \.self) { i in
                    let (xr,yr,angle) = pawSeeds[i]
                    Text("🐾").font(.system(size: 20)).foregroundColor(.white.opacity(0.10))
                        .rotationEffect(.degrees(angle))
                        .position(x: geo.size.width * xr + pawDrift[i].width, y: geo.size.height * yr + pawDrift[i].height)
                        .opacity(pawOpacity)
                }
            }

            VStack(spacing: 0) {
                Spacer()
                // Logo
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.appRose.opacity(0.25), Color.appPurple.opacity(0.18)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 130, height: 130).blur(radius: 20)
                    Circle()
                        .fill(Color.white.opacity(0.07))
                        .frame(width: 110, height: 110)
                        .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
                    Text("🐱").font(.system(size: 58))
                }
                .offset(y: logoFloat)
                .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: logoFloat)

                Spacer().frame(height: 32)

                VStack(spacing: 10) {
                    Text("Cat Cuddle")
                        .font(.system(size: 38, weight: .black, design: .rounded)).foregroundColor(.white)
                    Text("Tap the button to start cuddling\nsome adorable kittens!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.62)).multilineTextAlignment(.center).lineSpacing(4)
                }
                .opacity(contentOpacity).offset(y: contentOffset)

                Spacer().frame(height: 44)

                Button(action: { withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) { gameState.currentScreen = .selection } }) {
                    HStack(spacing: 8) {
                        Text("Play Now").font(.system(size: 18, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.right").font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white).frame(width: 200, height: 56)
                    .background(LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: Color.appRose.opacity(0.45), radius: 16, x: 0, y: 8)
                }
                .buttonStyle(ScalePressStyle())
                .opacity(contentOpacity).offset(y: contentOffset)

                Spacer()
                Text("© 2025 CatCudding").font(.system(size: 12)).foregroundColor(.white.opacity(0.22)).padding(.bottom, 32)
                    .opacity(contentOpacity)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true).delay(0.3)) { logoFloat = -10 }
            withAnimation(.easeOut(duration: 0.7).delay(0.3)) { contentOpacity = 1; contentOffset = 0 }
            withAnimation(.easeIn(duration: 1.0).delay(0.5)) { pawOpacity = 1 }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true).delay(0.6)) {
                for i in pawDrift.indices { pawDrift[i] = CGSize(width: .random(in:-12...12), height: .random(in:-18...8)) }
            }
        }
    }
}

// MARK: - Selection Screen
struct SelectionScreen: View {
    @ObservedObject var gameState: GameState
    @State private var cardsVisible = false

    var body: some View {
        ZStack {
            AppBackground(); AmbientGlow()
            VStack(spacing: 0) {
                HStack {
                    BackButton { withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) { gameState.currentScreen = .welcome } }
                    Spacer()
                }
                .padding(.horizontal, 20).padding(.top, 8)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Choose Your Cat")
                        .font(.system(size: 30, weight: .black, design: .rounded)).foregroundColor(.white)
                    Text("Find your purrfect pal 🐾")
                        .font(.system(size: 15, weight: .medium)).foregroundColor(.white.opacity(0.55))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(Array(gameState.cats.enumerated()), id: \.element.id) { index, cat in
                            CatSelectionCard(cat: cat, imageSource: gameState.catImages[index], isSelected: gameState.selectedCat?.id == cat.id) {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.65)) { gameState.selectCat(cat) }
                            }
                            .opacity(cardsVisible ? 1 : 0).offset(y: cardsVisible ? 0 : 22)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(Double(index) * 0.08), value: cardsVisible)
                        }
                        if let customCat = gameState.customCat {
                            CatSelectionCard(cat: customCat, imageSource: gameState.customCatImage, isSelected: gameState.selectedCat?.id == customCat.id) {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.65)) { gameState.selectCat(customCat) }
                            }
                            .opacity(cardsVisible ? 1 : 0).offset(y: cardsVisible ? 0 : 22)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.24), value: cardsVisible)
                        }
                        AddCustomCatCard(gameState: gameState)
                            .opacity(cardsVisible ? 1 : 0).offset(y: cardsVisible ? 0 : 22)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.30), value: cardsVisible)
                    }
                    .padding(.horizontal, 20).padding(.bottom, 16)
                }

                PrimaryButton(title: "Let's Cuddle! 🐱", action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) { gameState.currentScreen = .game }
                }, isEnabled: gameState.selectedCat != nil)
                .padding(.horizontal, 20).padding(.bottom, 36)
                .opacity(cardsVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.35), value: cardsVisible)
            }
        }
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { withAnimation { cardsVisible = true } } }
    }
}

// MARK: - Add Custom Cat Card
struct AddCustomCatCard: View {
    @ObservedObject var gameState: GameState
    @State private var showingNameAlert = false
    @State private var tempCatName = ""
    @State private var selectedImage: UIImage?
    @State private var isProcessingImage = false

    var body: some View {
        PhotosPicker(selection: Binding<PhotosPickerItem?>(
            get: { nil },
            set: { item in
                Task {
                    if let item, let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
                        selectedImage = img; showingNameAlert = true
                    }
                }
            }
        ), matching: .images) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(Color.appPurple.opacity(0.18)).frame(width: 56, height: 56)
                        .overlay(Circle().stroke(Color.appPurple.opacity(0.5), lineWidth: 1.5))
                    if isProcessingImage {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .appPurple))
                    } else {
                        Image(systemName: "plus.circle.fill").font(.system(size: 26)).foregroundColor(.appPurple)
                    }
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Add Your Cat").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundColor(.white)
                    Text(isProcessingImage ? "Processing image..." : "Upload your own photo!")
                        .font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "arrow.right").font(.system(size: 14, weight: .semibold)).foregroundColor(.white.opacity(0.35))
            }
            .padding(18)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(LinearGradient(colors: [Color.appPurple.opacity(0.5), Color.appBlue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])))
        }
        .buttonStyle(.plain).disabled(isProcessingImage)
        .alert("Name Your Cat", isPresented: $showingNameAlert) {
            TextField("Enter cat name", text: $tempCatName)
            Button("Add Cat") {
                if let img = selectedImage {
                    isProcessingImage = true
                    gameState.addCustomCat(image: img, name: tempCatName)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { tempCatName = ""; selectedImage = nil; isProcessingImage = false }
                }
            }
            Button("Cancel", role: .cancel) { tempCatName = ""; selectedImage = nil }
        } message: {
            Text("Give your cat a special name! We'll automatically remove the background.")
        }
    }
}

// MARK: - Cat Selection Card
struct CatSelectionCard: View {
    let cat: Cat; let imageSource: Any?; let isSelected: Bool; let onTap: () -> Void
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
                            Image(name).resizable().aspectRatio(contentMode: .fill).frame(width:48,height:48).clipShape(Circle())
                        } else if let img = imageSource as? UIImage {
                            Image(uiImage: img).resizable().aspectRatio(contentMode: .fill).frame(width:48,height:48).clipShape(Circle())
                        } else {
                            Text(cat.emoji).font(.system(size: 26))
                        }
                    }
                }
                .overlay(Circle().stroke(isSelected ? Color.clear : Color.white.opacity(0.15), lineWidth: 1.5))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(cat.name).font(.system(size: 16, weight: .bold, design: .rounded)).foregroundColor(.white)
                        if cat.isCustom {
                            Text("CUSTOM").font(.system(size: 9, weight: .black)).foregroundColor(.appPurple)
                                .padding(.horizontal,6).padding(.vertical,2)
                                .background(Color.appPurple.opacity(0.15)).clipShape(Capsule())
                        }
                    }
                    Text(cat.description).font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(isSelected
                            ? LinearGradient(colors: [Color(red:0.22,green:0.78,blue:0.44), .mint], startPoint: .top, endPoint: .bottom)
                            : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 28, height: 28)
                    if isSelected { Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white) }
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
                        lineWidth: isSelected ? 1.5 : 1))
            .shadow(color: isSelected ? Color.appRose.opacity(0.2) : .clear, radius: 12, x: 0, y: 4)
            .scaleEffect(isSelected ? 1.01 : 1.0)
        }
        .buttonStyle(ScalePressStyle())
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Game Screen
struct GameScreen: View {
    @ObservedObject var gameState: GameState

    private func catHeadAngle(catCenter: CGPoint) -> Double {
        switch gameState.currentMode {
        case .cuddle:
            guard let drag = gameState.petDragLocation else { return 0 }
            return max(-12, min(12, (drag.x - catCenter.x) * 0.07))
        case .treats:
            let live = gameState.draggableTreats.filter { !$0.isEaten && $0.isDragging }
            let pool = live.isEmpty ? gameState.draggableTreats.filter { !$0.isEaten } : live
            guard let t = pool.min(by: {
                hypot($0.position.x - catCenter.x, $0.position.y - catCenter.y) <
                hypot($1.position.x - catCenter.x, $1.position.y - catCenter.y)
            }) else { return 0 }
            return max(-15, min(15, (t.position.x - catCenter.x) * 0.08))
        case .toys:
            guard let laser = gameState.laserPosition else { return 0 }
            return max(-20, min(20, (laser.x - catCenter.x) * 0.10))
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppBackground(); AmbientGlow()
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 12) {
                        BackButton {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                gameState.currentScreen = .selection; gameState.resetGame()
                            }
                        }
                        Spacer()
                        VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text(gameState.selectedCat?.emoji ?? "🐱").font(.system(size: 15))
                                Text(gameState.selectedCat?.name ?? "").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white)
                            }
                            HStack(spacing: 8) {
                                HappinessBar(value: gameState.happiness).frame(width: 120, height: 8)
                                Text("\(Int(gameState.happiness))%")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7)).frame(width: 36, alignment: .leading)
                            }
                        }
                        Spacer()
                        Color.clear.frame(width: 42, height: 42)
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)

                    // Play area
                    GeometryReader { playGeo in
                        let catCenter = CGPoint(x: playGeo.size.width / 2, y: playGeo.size.height / 2 - 20)
                        ZStack {
                            // Purr waves (Cuddle)
                            if gameState.currentMode == .cuddle && gameState.purrIntensity > 0.05 {
                                PurrWaveView(intensity: gameState.purrIntensity)
                                    .position(catCenter)
                            }

                            // Cat
                            if let cat = gameState.selectedCat {
                                RealCatView(
                                    imageSource: gameState.getImageForCat(cat), size: 240,
                                    isHappy: gameState.happiness > 50, isIdle: true,
                                    isBeingPetted: gameState.isBeingPetted,
                                    isExcited: gameState.catIsExcited,
                                    isZoomedIn: gameState.catZoomedIn,
                                    headAngle: catHeadAngle(catCenter: catCenter)
                                )
                                .position(catCenter)
                            }

                            // Cuddle: floating hearts/sparkles
                            if gameState.currentMode == .cuddle {
                                ForEach(gameState.hearts) { h in
                                    Text("🐾").font(.title2).position(x: h.x, y: h.y).opacity(h.opacity)
                                }
                                ForEach(gameState.sparkles) { s in
                                    Text("✨").font(.title3).position(x: s.x, y: s.y).opacity(s.opacity)
                                }
                            }

                            // Treats
                            if gameState.currentMode == .treats {
                                ForEach(gameState.draggableTreats) { treat in
                                    if !treat.isEaten {
                                        TreatBubble(treat: treat, catCenter: catCenter)
                                            .position(treat.position)
                                            .opacity(treat.opacity)
                                            .scaleEffect(treat.scale)
                                            .gesture(DragGesture(minimumDistance: 0)
                                                .onChanged { v in gameState.dragTreat(treat.id, to: v.location) }
                                                .onEnded { _ in gameState.dropTreat(treat.id, catCenter: catCenter) }
                                            )
                                    }
                                }
                            }

                            // Toys: laser dot
                            if gameState.currentMode == .toys, let laser = gameState.laserPosition {
                                LaserDotView().position(laser).zIndex(10)
                            }

                            // Pounce effect
                            if gameState.showPounceEffect {
                                PounceEffect()
                                    .position(gameState.laserPosition ?? catCenter)
                                    .transition(.opacity).zIndex(20)
                            }

                            // Feeding complete message
                            if gameState.showFeedingComplete {
                                VStack(spacing: 10) {
                                    Text("😸").font(.system(size: 60))
                                    Text("Doydum! 🐟")
                                        .font(.system(size: 24, weight: .black, design: .rounded)).foregroundColor(.white)
                                        .padding(.horizontal, 28).padding(.vertical, 12)
                                        .background(LinearGradient(colors: [.appRose, .appCoral], startPoint: .leading, endPoint: .trailing))
                                        .clipShape(Capsule())
                                        .shadow(color: Color.appRose.opacity(0.4), radius: 12, x: 0, y: 5)
                                }
                                .transition(.scale(scale: 0.8).combined(with: .opacity)).zIndex(30)
                            }

                            // Cuddle gesture overlay
                            if gameState.currentMode == .cuddle {
                                Color.clear.contentShape(Rectangle())
                                    .gesture(DragGesture(minimumDistance: 0)
                                        .onChanged { v in gameState.startPetting(at: v.location) }
                                        .onEnded { _ in gameState.stopPetting() }
                                    )
                            }

                            // Toys gesture overlay
                            if gameState.currentMode == .toys {
                                Color.clear.contentShape(Rectangle())
                                    .gesture(DragGesture(minimumDistance: 0)
                                        .onChanged { v in gameState.moveLaser(to: v.location) }
                                        .onEnded { _ in gameState.endLaser() }
                                    )
                            }
                        }
                        .onChange(of: gameState.currentMode) {
                            if gameState.currentMode == .treats { gameState.setupTreats(in: playGeo.size) }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // Instruction hint
                    Group {
                        switch gameState.currentMode {
                        case .cuddle:
                            Label("Drag to pet \(gameState.selectedCat?.name ?? "your cat")!", systemImage: "hand.draw.fill")
                        case .treats:
                            Label("Drag treats to your cat's mouth!", systemImage: "hand.point.up.left.fill")
                        case .toys:
                            Label("Touch & drag to move the laser!", systemImage: "laser.burst")
                        }
                    }
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.52)).padding(.bottom, 14)

                    // Bottom mode tab bar
                    HStack(spacing: 8) {
                        ModeTabButton(icon: "🐱", label: "Cuddle", isActive: gameState.currentMode == .cuddle) { gameState.switchMode(to: .cuddle) }
                        ModeTabButton(icon: "🍖", label: "Treats", isActive: gameState.currentMode == .treats) { gameState.switchMode(to: .treats) }
                        ModeTabButton(icon: "⭐", label: "Toys",   isActive: gameState.currentMode == .toys)   { gameState.switchMode(to: .toys) }
                    }
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.14), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.22), radius: 16, x: 0, y: 6)
                    .padding(.horizontal, 40).padding(.bottom, 36)
                }

                // Celebration overlay
                if gameState.showFullScreenCelebration, let cat = gameState.selectedCat {
                    FullScreenCelebrationView(imageSource: gameState.getImageForCat(cat), catName: cat.name, gameState: gameState)
                        .transition(.opacity.combined(with: .scale(scale: 0.96))).zIndex(200)
                }
            }
        }
    }
}

// MARK: - Mode Tab Button
struct ModeTabButton: View {
    let icon: String; let label: String; let isActive: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(icon).font(.system(size: 22))
                Text(label).font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? .white : .white.opacity(0.42))
            }
            .frame(minWidth: 72, minHeight: 60)
            .background {
                if isActive {
                    LinearGradient(colors: [Color.appRose.opacity(0.55), Color.appCoral.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .clipShape(Capsule())
                }
            }
        }
        .buttonStyle(ScalePressStyle())
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isActive)
    }
}

// MARK: - Main App
struct CatCuddleApp: View {
    @StateObject private var gameState = GameState()
    var body: some View {
        ZStack {
            switch gameState.currentScreen {
            case .welcome:
                WelcomeScreen(gameState: gameState)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.97)), removal: .opacity.combined(with: .scale(scale: 1.03))))
            case .selection:
                SelectionScreen(gameState: gameState)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)), removal: .opacity.combined(with: .move(edge: .leading))))
            case .game:
                GameScreen(gameState: gameState)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)), removal: .opacity.combined(with: .move(edge: .leading))))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: gameState.currentScreen)
    }
}

struct CatCuddleApp_Previews: PreviewProvider {
    static var previews: some View { CatCuddleApp() }
}
