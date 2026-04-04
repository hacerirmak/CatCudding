import SwiftUI
import AVFoundation
import Combine
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

// MARK: - Design System
private extension ShapeStyle where Self == LinearGradient {
    static var appBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.04, blue: 0.18),
                Color(red: 0.14, green: 0.05, blue: 0.28),
                Color(red: 0.20, green: 0.06, blue: 0.22)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    static var roseGradient: LinearGradient {
        LinearGradient(colors: [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 1, green: 0.58, blue: 0.28)],
                       startPoint: .leading, endPoint: .trailing)
    }
    static var purpleGradient: LinearGradient {
        LinearGradient(colors: [Color(red: 0.55, green: 0.35, blue: 0.95), Color(red: 0.35, green: 0.55, blue: 0.98)],
                       startPoint: .leading, endPoint: .trailing)
    }
}

// MARK: - Reusable Components

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 58)
                .background(
                    Group {
                        if isEnabled {
                            LinearGradient(colors: [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 1, green: 0.58, blue: 0.28)],
                                           startPoint: .leading, endPoint: .trailing)
                        } else {
                            LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)],
                                           startPoint: .leading, endPoint: .trailing)
                        }
                    }
                )
                .clipShape(Capsule())
                .shadow(color: isEnabled ? Color(red: 1, green: 0.38, blue: 0.52).opacity(0.4) : .clear,
                        radius: 12, x: 0, y: 6)
                .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = true } }
                .onEnded { _ in withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { isPressed = false } }
        )
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
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HappinessBar: View {
    let value: Double
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 8)

                Capsule()
                    .fill(LinearGradient(
                        colors: value > 70
                            ? [Color.green.opacity(0.9), Color.mint]
                            : [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 1, green: 0.62, blue: 0.30)],
                        startPoint: .leading, endPoint: .trailing
                    ))
                    .frame(width: geo.size.width * CGFloat(value / 100), height: 8)
                    .shadow(color: Color(red: 1, green: 0.38, blue: 0.52).opacity(0.5), radius: 4, x: 0, y: 0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: value)
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Full Screen Celebration View
struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState

    @State private var celebrationHearts: [FloatingElement] = []
    @State private var celebrationSparkles: [FloatingElement] = []
    @State private var appear = false
    @State private var pulse = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Elegant dark gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.10, green: 0.03, blue: 0.22),
                        Color(red: 0.25, green: 0.05, blue: 0.35),
                        Color(red: 0.35, green: 0.08, blue: 0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Soft glow blobs
                Circle()
                    .fill(Color(red: 1, green: 0.38, blue: 0.52).opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: -80, y: -200)

                Circle()
                    .fill(Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.12))
                    .frame(width: 250, height: 250)
                    .blur(radius: 50)
                    .offset(x: 100, y: 200)

                // Floating paw prints
                ForEach(celebrationHearts) { heart in
                    Text("🐾")
                        .font(.system(size: 22))
                        .position(x: heart.x, y: heart.y)
                        .opacity(heart.opacity)
                }
                ForEach(celebrationSparkles) { sparkle in
                    Text("✨")
                        .font(.system(size: 18))
                        .position(x: sparkle.x, y: sparkle.y)
                        .opacity(sparkle.opacity)
                }

                VStack(spacing: 28) {
                    // Badge
                    Text("🎉 Amazing! 🎉")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .scaleEffect(pulse ? 1.06 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 20)
                        .padding(.top, 60)

                    Text("\(catName) is super happy!")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 15)

                    // Cat image card
                    Group {
                        if let imageName = imageSource as? String {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if let uiImage = imageSource as? UIImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Text("🐱").font(.system(size: 100))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.72, maxHeight: geometry.size.height * 0.42)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 0.55, green: 0.35, blue: 0.95)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .shadow(color: Color(red: 1, green: 0.38, blue: 0.52).opacity(0.35), radius: 24, x: 0, y: 8)
                    .scaleEffect(appear ? 1.0 : 0.7)
                    .opacity(appear ? 1 : 0)

                    // Message
                    VStack(spacing: 8) {
                        Text("💖 Perfect Happiness Achieved! 💖")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("You've made \(catName) the happiest cat ever!")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 10)

                    Spacer()

                    // Continue button
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.showFullScreenCelebration = false
                            gameState.happiness = 0
                        }
                    }) {
                        Text("Continue Playing")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 1, green: 0.58, blue: 0.28)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color(red: 1, green: 0.38, blue: 0.52).opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 32)
                    .padding(.bottom, 44)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 20)
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) { appear = true }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.5)) { pulse = true }
            generateCelebrationEffects(in: UIScreen.main.bounds.size)
        }
    }

    private func generateCelebrationEffects(in size: CGSize) {
        for i in 0..<18 {
            let heart = FloatingElement(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
            celebrationHearts.append(heart)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.12) {
                withAnimation(.easeOut(duration: 3.0)) {
                    if let idx = celebrationHearts.firstIndex(where: { $0.id == heart.id }) {
                        celebrationHearts[idx] = FloatingElement(x: heart.x + CGFloat.random(in: -80...80), y: heart.y - 220, opacity: 0)
                    }
                }
            }
        }
        for i in 0..<25 {
            let sparkle = FloatingElement(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
            celebrationSparkles.append(sparkle)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    if let idx = celebrationSparkles.firstIndex(where: { $0.id == sparkle.id }) {
                        celebrationSparkles[idx] = FloatingElement(x: sparkle.x + CGFloat.random(in: -120...120), y: sparkle.y - 130, opacity: 0)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            celebrationHearts.removeAll()
            celebrationSparkles.removeAll()
        }
    }
}

// MARK: - Models
struct Cat: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let breed: String
    let color: Color
    let emoji: String
    let isCustom: Bool

    init(name: String, description: String, breed: String, color: Color, emoji: String, isCustom: Bool = false) {
        self.name = name
        self.description = description
        self.breed = breed
        self.color = color
        self.emoji = emoji
        self.isCustom = isCustom
    }

    static func == (lhs: Cat, rhs: Cat) -> Bool { lhs.id == rhs.id }
}

struct FloatingElement: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    var opacity: Double = 1.0
}

struct Treat: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var isEaten: Bool = false
    var opacity: Double = 1.0
    var scale: CGFloat = 1.0
}

struct MouseToy: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var rotation: Double = 0
}

// MARK: - Game State
class GameState: ObservableObject {
    @Published var currentScreen: ScreenType = .welcome
    @Published var selectedCat: Cat?
    @Published var happiness: Double = 0
    @Published var hearts: [FloatingElement] = []
    @Published var sparkles: [FloatingElement] = []
    @Published var isBeingPetted: Bool = false
    @Published var showFullScreenCelebration: Bool = false
    @Published var customCatImage: UIImage?
    @Published var customCatName: String = ""
    @Published var showingImagePicker: Bool = false

    @Published var currentMode: GameMode = .cuddle

    @Published var treats: [Treat] = []
    @Published var isFeeding: Bool = false
    @Published var showFeedingComplete: Bool = false
    @Published var isTreatsButtonDisabled: Bool = false

    @Published var mouseToy: MouseToy?
    @Published var isPlayingWithToy: Bool = false
    @Published var catIsExcited: Bool = false
    @Published var catZoomedIn: Bool = false
    @Published var showToysComplete: Bool = false

    let cats = [
        Cat(name: "Whiskers", description: "Super playful!", breed: "Orange Tabby", color: .orange, emoji: "🧡"),
        Cat(name: "Cloudy Paws", description: "Gentle giant", breed: "British Shorthair", color: .gray, emoji: "🩶"),
        Cat(name: "Shadow Pounce", description: "Mischievous explorer", breed: "Black Kitten", color: .black, emoji: "🖤")
    ]

    let catImages = ["cat1", "cat2", "cat3"]

    var customCat: Cat? {
        guard customCatImage != nil, !customCatName.isEmpty else { return nil }
        return Cat(name: customCatName.isEmpty ? "My Cat" : customCatName, description: "My special friend!",
                   breed: "Custom Cat", color: .purple, emoji: "💜", isCustom: true)
    }

    var allCats: [Cat] {
        var all = cats
        if let custom = customCat { all.append(custom) }
        return all
    }

    private var audioPlayer: AVAudioPlayer?

    func selectCat(_ cat: Cat) { selectedCat = cat }

    func addCustomCat(image: UIImage, name: String) {
        removeBackground(from: image) { processedImage in
            DispatchQueue.main.async {
                self.customCatImage = processedImage ?? image
                self.customCatName = name.isEmpty ? "My Cat" : name
            }
        }
    }

    private func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        let fixedImage = fixImageOrientation(image)
        guard let inputImage = CIImage(image: fixedImage) else { completion(nil); return }

        let request = VNGenerateForegroundInstanceMaskRequest { request, error in
            guard error == nil,
                  let results = request.results as? [VNInstanceMaskObservation],
                  let result = results.first else { completion(nil); return }
            do {
                let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: VNImageRequestHandler(ciImage: inputImage))
                let maskImage = CIImage(cvPixelBuffer: maskPixelBuffer)
                let filter = CIFilter.blendWithMask()
                filter.inputImage = inputImage
                filter.backgroundImage = CIImage.empty()
                filter.maskImage = maskImage
                let context = CIContext()
                if let outputImage = filter.outputImage,
                   let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    completion(UIImage(cgImage: cgImage, scale: fixedImage.scale, orientation: .up))
                } else { completion(nil) }
            } catch {
                print("Error processing mask: \(error)")
                completion(nil)
            }
        }

        let handler = VNImageRequestHandler(ciImage: inputImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do { try handler.perform([request]) } catch { print("Error: \(error)"); completion(nil) }
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

    func getImageForCat(_ cat: Cat) -> Any? {
        if cat.isCustom { return customCatImage }
        if let index = cats.firstIndex(of: cat) { return catImages[index] }
        return nil
    }

    func petCat(at location: CGPoint) {
        withAnimation(.easeOut(duration: 0.5)) {
            isBeingPetted = true
            happiness = min(happiness + 10, 100)
            if happiness >= 100 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { self.showFullScreenCelebration = true }
                }
            }
        }
        generateHearts(at: location)
        generateSparkles(at: location)
        playPurrSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { self.isBeingPetted = false }
        }
    }

    private func generateHearts(at location: CGPoint) {
        let newHearts = (0..<3).map { _ in
            FloatingElement(x: location.x + CGFloat.random(in: -50...50), y: location.y + CGFloat.random(in: -25...25))
        }
        hearts.append(contentsOf: newHearts)
        for (index, heart) in newHearts.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                withAnimation(.easeOut(duration: 2.0)) {
                    if let i = self.hearts.firstIndex(where: { $0.id == heart.id }) {
                        self.hearts[i] = FloatingElement(x: heart.x, y: heart.y - 60, opacity: 0)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hearts.removeAll { h in newHearts.contains { $0.id == h.id } }
        }
    }

    private func generateSparkles(at location: CGPoint) {
        let newSparkles = (0..<5).map { _ in
            FloatingElement(x: location.x + CGFloat.random(in: -60...60), y: location.y + CGFloat.random(in: -40...40))
        }
        sparkles.append(contentsOf: newSparkles)
        for (index, sparkle) in newSparkles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    if let i = self.sparkles.firstIndex(where: { $0.id == sparkle.id }) {
                        self.sparkles[i] = FloatingElement(x: sparkle.x, y: sparkle.y, opacity: 0)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.sparkles.removeAll { s in newSparkles.contains { $0.id == s.id } }
        }
    }

    private func playPurrSound() {
        AudioServicesPlaySystemSound(1104)
    }

    func resetGame() {
        happiness = 0
        hearts.removeAll(); sparkles.removeAll()
        isBeingPetted = false; showFullScreenCelebration = false
        treats.removeAll(); isFeeding = false; showFeedingComplete = false; isTreatsButtonDisabled = false
        mouseToy = nil; isPlayingWithToy = false; catIsExcited = false; catZoomedIn = false; showToysComplete = false
        currentMode = .cuddle
    }

    func switchMode(to newMode: GameMode) {
        guard newMode != currentMode else { return }
        switch currentMode {
        case .cuddle: hearts.removeAll(); sparkles.removeAll(); isBeingPetted = false
        case .treats: treats.removeAll(); isFeeding = false; showFeedingComplete = false; isTreatsButtonDisabled = false
        case .toys: mouseToy = nil; isPlayingWithToy = false; catIsExcited = false; catZoomedIn = false; showToysComplete = false
        }
        withAnimation(.easeOut(duration: 0.3)) { happiness = 0 }
        showFullScreenCelebration = false
        currentMode = newMode
    }

    func startFeeding(in size: CGSize) {
        guard !isFeeding && currentMode == .treats else { return }
        isFeeding = true; isTreatsButtonDisabled = true
        let treatCount = 8
        let centerX = size.width / 2, centerY = size.height / 2, radius: CGFloat = 120
        for i in 0..<treatCount {
            let angle = (CGFloat(i) / CGFloat(treatCount)) * 2 * .pi
            treats.append(Treat(x: centerX + cos(angle) * radius, y: centerY + sin(angle) * radius))
        }
        eatNextTreat()
    }

    private func eatNextTreat() {
        guard currentMode == .treats, !treats.isEmpty else { return }
        guard let nextIndex = treats.firstIndex(where: { !$0.isEaten }) else { completeFeedingSession(); return }
        treats[nextIndex].isEaten = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, self.currentMode == .treats, nextIndex < self.treats.count else { return }
            withAnimation(.easeOut(duration: 0.5)) {
                self.treats[nextIndex].opacity = 0
                self.treats[nextIndex].scale = 0.5
            }
            let progressIncrement = 100.0 / Double(self.treats.count)
            withAnimation(.easeInOut(duration: 0.3)) { self.happiness = min(self.happiness + progressIncrement, 100) }
            AudioServicesPlaySystemSound(1103)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in self?.eatNextTreat() }
        }
    }

    private func completeFeedingSession() {
        guard currentMode == .treats else { return }
        withAnimation { showFeedingComplete = true }
        if happiness >= 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self, self.currentMode == .treats else { return }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { self.showFullScreenCelebration = true }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            withAnimation { self.showFeedingComplete = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.treats.removeAll(); self.isFeeding = false; self.isTreatsButtonDisabled = false
            }
        }
    }

    func startPlayingWithToys(in size: CGSize) {
        guard !isPlayingWithToy && currentMode == .toys else { return }
        isPlayingWithToy = true; catIsExcited = true
        mouseToy = MouseToy(x: 80, y: 80)
        animateMouseMovement(in: size)
        startProgressTimer()
    }

    private func animateMouseMovement(in size: CGSize) {
        guard currentMode == .toys, let _ = mouseToy else { return }
        let padding: CGFloat = 80
        let waypoints: [(x: CGFloat, y: CGFloat, rotation: Double)] = [
            (padding, padding, 0),
            (size.width - padding, padding, 0),
            (size.width - padding, size.height - 200, 180),
            (padding, size.height - 200, 180)
        ]
        animateToNextWaypoint(waypoints: waypoints, currentIndex: 0, in: size)
    }

    private func animateToNextWaypoint(waypoints: [(x: CGFloat, y: CGFloat, rotation: Double)], currentIndex: Int, in size: CGSize) {
        guard currentMode == .toys, mouseToy != nil else { return }
        let nextIndex = (currentIndex + 1) % waypoints.count
        let waypoint = waypoints[nextIndex]
        withAnimation(.easeInOut(duration: 2.0)) {
            mouseToy?.x = waypoint.x; mouseToy?.y = waypoint.y; mouseToy?.rotation = waypoint.rotation
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.animateToNextWaypoint(waypoints: waypoints, currentIndex: nextIndex, in: size)
        }
    }

    private func startProgressTimer() {
        let totalDuration: Double = 8.0, steps = 80
        let increment = 100.0 / Double(steps), stepDuration = totalDuration / Double(steps)
        for i in 0..<steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * stepDuration) { [weak self] in
                guard let self = self, self.currentMode == .toys else { return }
                withAnimation(.linear(duration: stepDuration)) { self.happiness = min(self.happiness + increment, 100) }
                if self.happiness >= 100 { self.completeToysSession() }
            }
        }
    }

    private func completeToysSession() {
        guard currentMode == .toys else { return }
        catIsExcited = false
        withAnimation(.easeOut(duration: 0.5)) { mouseToy = nil }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, self.currentMode == .toys else { return }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) { self.catZoomedIn = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                withAnimation { self.showToysComplete = true }
                if self.happiness >= 100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                        guard let self = self, self.currentMode == .toys else { return }
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { self.showFullScreenCelebration = true }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else { return }
                    withAnimation { self.showToysComplete = false; self.catZoomedIn = false }
                    self.isPlayingWithToy = false
                }
            }
        }
    }
}

enum ScreenType { case welcome, selection, game }
enum GameMode { case cuddle, treats, toys }

// MARK: - Real Cat Image View
struct RealCatView: View {
    let imageSource: Any?
    let size: CGFloat
    let isHappy: Bool
    let isIdle: Bool
    let isBeingPetted: Bool
    let isExcited: Bool
    let isZoomedIn: Bool

    @State private var idleAnimation = false
    @State private var heartBeat = false
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Glow halo
            if isHappy {
                Circle()
                    .fill(Color(red: 1, green: 0.38, blue: 0.52).opacity(heartBeat ? 0.25 : 0.12))
                    .frame(width: size * 1.3, height: size * 1.3)
                    .blur(radius: 20)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: heartBeat)
            }

            Group {
                if let imageName = imageSource as? String {
                    Image(imageName).resizable().aspectRatio(contentMode: .fit)
                } else if let uiImage = imageSource as? UIImage {
                    Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fit)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .overlay(Text("🐱").font(.system(size: size * 0.3)))
                }
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: isHappy
                                ? [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 0.55, green: 0.35, blue: 0.95)]
                                : [Color.white.opacity(0.15), Color.white.opacity(0.05)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: isHappy ? 3 : 1
                    )
                    .opacity(isHappy ? (heartBeat ? 1.0 : 0.5) : 1.0)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 16, x: 0, y: 8)
            .scaleEffect(isZoomedIn ? 1.35 : (isBeingPetted ? 1.08 : (idleAnimation ? 1.015 : 1.0)))
            .rotationEffect(.degrees(isBeingPetted ? 1.5 : (isExcited ? shakeOffset * 1.5 : 0)))
            .offset(x: isExcited ? shakeOffset : 0, y: isZoomedIn ? -30 : 0)
            .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isBeingPetted)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: idleAnimation)

            if isHappy {
                HStack(spacing: 6) {
                    Text("😊").font(.title2)
                    Text("💖").font(.title3)
                }
                .scaleEffect(heartBeat ? 1.15 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: heartBeat)
                .offset(y: -size * 0.42)
            }
        }
        .onAppear {
            if isIdle { withAnimation { idleAnimation = true } }
            if isHappy { withAnimation { heartBeat = true } }
            if isExcited { startShakeAnimation() }
        }
        .onChange(of: isHappy) { newValue in withAnimation { heartBeat = newValue } }
        .onChange(of: isExcited) { newValue in
            if newValue { startShakeAnimation() } else { shakeOffset = 0 }
        }
    }

    private func startShakeAnimation() {
        withAnimation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) { shakeOffset = 3 }
    }
}

// MARK: - Custom Shapes
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct Curve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

// MARK: - Welcome Screen
struct WelcomeScreen: View {
    @ObservedObject var gameState: GameState
    @State private var logoScale: CGFloat = 0.6
    @State private var logoFloat: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    @State private var pawOffsets: [CGSize] = (0..<6).map { _ in CGSize(width: CGFloat.random(in: -20...20), height: CGFloat.random(in: 0...30)) }
    @State private var pawOpacity: Double = 0

    private let pawPositions: [(CGFloat, CGFloat, Double)] = [
        (0.15, 0.12, -15), (0.82, 0.08, 20), (0.08, 0.55, 10),
        (0.88, 0.48, -8), (0.22, 0.82, 25), (0.75, 0.78, -20)
    ]

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.04, blue: 0.18),
                    Color(red: 0.14, green: 0.05, blue: 0.28),
                    Color(red: 0.20, green: 0.06, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Ambient glow blobs
            Circle()
                .fill(Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.18))
                .frame(width: 350, height: 350)
                .blur(radius: 80)
                .offset(x: -80, y: -200)

            Circle()
                .fill(Color(red: 1, green: 0.38, blue: 0.52).opacity(0.14))
                .frame(width: 280, height: 280)
                .blur(radius: 70)
                .offset(x: 120, y: 250)

            // Floating paw prints
            GeometryReader { geo in
                ForEach(0..<pawPositions.count, id: \.self) { i in
                    let (xRatio, yRatio, angle) = pawPositions[i]
                    Text("🐾")
                        .font(.system(size: 22))
                        .foregroundColor(.white.opacity(0.12))
                        .rotationEffect(.degrees(angle))
                        .position(
                            x: geo.size.width * xRatio + pawOffsets[i].width,
                            y: geo.size.height * yRatio + pawOffsets[i].height
                        )
                        .opacity(pawOpacity)
                }
            }

            VStack(spacing: 0) {
                Spacer()

                // Logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 1, green: 0.38, blue: 0.52).opacity(0.3), Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.2)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)
                        .blur(radius: 20)

                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 110, height: 110)
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.18), lineWidth: 1)
                        )

                    Text("🐱")
                        .font(.system(size: 56))
                }
                .scaleEffect(logoScale)
                .offset(y: logoFloat)

                Spacer().frame(height: 32)

                // Title & Subtitle
                VStack(spacing: 10) {
                    Text("Cat Cuddle")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Text("Tap the button to start cuddling\nsome adorable kittens!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .opacity(contentOpacity)
                .offset(y: contentOffset)

                Spacer().frame(height: 44)

                // CTA Button
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        gameState.currentScreen = .selection
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("Play Now")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 1, green: 0.58, blue: 0.28)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color(red: 1, green: 0.38, blue: 0.52).opacity(0.45), radius: 16, x: 0, y: 8)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(contentOpacity)
                .offset(y: contentOffset)

                Spacer()

                Text("© 2025 CatCudding")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.25))
                    .padding(.bottom, 32)
                    .opacity(contentOpacity)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1)) {
                logoScale = 1.0
            }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true).delay(0.5)) {
                logoFloat = -10
            }
            withAnimation(.easeOut(duration: 0.7).delay(0.35)) {
                contentOpacity = 1
                contentOffset = 0
            }
            withAnimation(.easeIn(duration: 1.0).delay(0.6)) {
                pawOpacity = 1
            }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true).delay(0.8)) {
                for i in 0..<pawOffsets.count {
                    pawOffsets[i] = CGSize(width: CGFloat.random(in: -15...15), height: CGFloat.random(in: -20...10))
                }
            }
        }
    }
}

// MARK: - Cat Selection Screen
struct SelectionScreen: View {
    @ObservedObject var gameState: GameState
    @State private var cardsVisible = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.04, blue: 0.18),
                    Color(red: 0.14, green: 0.05, blue: 0.28),
                    Color(red: 0.20, green: 0.06, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Ambient glows
            Circle()
                .fill(Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.14))
                .frame(width: 300, height: 300).blur(radius: 70)
                .offset(x: 120, y: -180)

            Circle()
                .fill(Color(red: 1, green: 0.38, blue: 0.52).opacity(0.10))
                .frame(width: 250, height: 250).blur(radius: 60)
                .offset(x: -100, y: 200)

            VStack(spacing: 0) {
                // Header
                HStack {
                    BackButton {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            gameState.currentScreen = .welcome
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // Title
                VStack(alignment: .leading, spacing: 6) {
                    Text("Choose Your Cat")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Text("Find your purrfect pal 🐾")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.55))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)

                // Scrollable cat list
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(Array(gameState.cats.enumerated()), id: \.element.id) { index, cat in
                            CatSelectionCard(
                                cat: cat,
                                imageSource: gameState.catImages[index],
                                isSelected: gameState.selectedCat?.id == cat.id
                            ) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                                    gameState.selectCat(cat)
                                }
                            }
                            .opacity(cardsVisible ? 1 : 0)
                            .offset(y: cardsVisible ? 0 : 24)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(Double(index) * 0.08), value: cardsVisible)
                        }

                        if let customCat = gameState.customCat {
                            CatSelectionCard(
                                cat: customCat,
                                imageSource: gameState.customCatImage,
                                isSelected: gameState.selectedCat?.id == customCat.id
                            ) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                                    gameState.selectCat(customCat)
                                }
                            }
                            .opacity(cardsVisible ? 1 : 0)
                            .offset(y: cardsVisible ? 0 : 24)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.24), value: cardsVisible)
                        }

                        AddCustomCatCard(gameState: gameState)
                            .opacity(cardsVisible ? 1 : 0)
                            .offset(y: cardsVisible ? 0 : 24)
                            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.30), value: cardsVisible)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }

                // Start button
                PrimaryButton(title: "Let's Cuddle! 🐱", action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        gameState.currentScreen = .game
                    }
                }, isEnabled: gameState.selectedCat != nil)
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
                .opacity(cardsVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.35), value: cardsVisible)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation { cardsVisible = true }
            }
        }
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
                    if let item = item,
                       let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        showingNameAlert = true
                    }
                }
            }
        ), matching: .images) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.18))
                        .frame(width: 56, height: 56)
                        .overlay(Circle().stroke(Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.5), lineWidth: 1.5))

                    if isProcessingImage {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.67, green: 0.47, blue: 0.98)))
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(Color(red: 0.67, green: 0.47, blue: 0.98))
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Add Your Cat")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(isProcessingImage ? "Processing image..." : "Upload your own photo!")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(18)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.5), Color.blue.opacity(0.3)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isProcessingImage)
        .alert("Name Your Cat", isPresented: $showingNameAlert) {
            TextField("Enter cat name", text: $tempCatName)
            Button("Add Cat") {
                if let image = selectedImage {
                    isProcessingImage = true
                    gameState.addCustomCat(image: image, name: tempCatName)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        tempCatName = ""; selectedImage = nil; isProcessingImage = false
                    }
                }
            }
            Button("Cancel", role: .cancel) { tempCatName = ""; selectedImage = nil }
        } message: {
            Text("Give your cat a special name! We'll automatically remove the background to make your cat look amazing.")
        }
    }
}

// MARK: - Cat Selection Card
struct CatSelectionCard: View {
    let cat: Cat
    let imageSource: Any?
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(isSelected
                              ? LinearGradient(colors: [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 1, green: 0.58, blue: 0.28)], startPoint: .topLeading, endPoint: .bottomTrailing)
                              : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 58, height: 58)

                    Group {
                        if let imageName = imageSource as? String {
                            Image(imageName).resizable().aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 48).clipShape(Circle())
                        } else if let uiImage = imageSource as? UIImage {
                            Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 48).clipShape(Circle())
                        } else {
                            Text(cat.emoji).font(.system(size: 26))
                        }
                    }
                }
                .overlay(
                    Circle()
                        .stroke(isSelected
                                ? Color.clear
                                : Color.white.opacity(0.15),
                                lineWidth: 1.5)
                )

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(cat.name)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        if cat.isCustom {
                            Text("CUSTOM")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(Color(red: 0.67, green: 0.47, blue: 0.98))
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color(red: 0.67, green: 0.47, blue: 0.98).opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    Text(cat.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                // Selection indicator
                ZStack {
                    Circle()
                        .fill(isSelected
                              ? LinearGradient(colors: [Color(red: 0.22, green: 0.78, blue: 0.44), Color.mint], startPoint: .top, endPoint: .bottom)
                              : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 28, height: 28)
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .overlay(Circle().stroke(Color.white.opacity(isSelected ? 0 : 0.12), lineWidth: 1))
            }
            .padding(16)
            .background(
                isSelected
                    ? AnyView(LinearGradient(colors: [Color(red: 1, green: 0.38, blue: 0.52).opacity(0.15), Color(red: 1, green: 0.58, blue: 0.28).opacity(0.08)], startPoint: .leading, endPoint: .trailing))
                    : AnyView(Color.white.opacity(0.07))
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        isSelected
                            ? LinearGradient(colors: [Color(red: 1, green: 0.38, blue: 0.52).opacity(0.8), Color(red: 1, green: 0.58, blue: 0.28).opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .shadow(color: isSelected ? Color(red: 1, green: 0.38, blue: 0.52).opacity(0.2) : .clear, radius: 12, x: 0, y: 4)
            .scaleEffect(isSelected ? 1.01 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Game Screen
struct GameScreen: View {
    @ObservedObject var gameState: GameState

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.04, blue: 0.18),
                        Color(red: 0.14, green: 0.05, blue: 0.28),
                        Color(red: 0.20, green: 0.06, blue: 0.22)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Ambient glows
                Circle()
                    .fill(Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.12))
                    .frame(width: 300, height: 300).blur(radius: 70)
                    .offset(x: 120, y: -160)
                Circle()
                    .fill(Color(red: 1, green: 0.38, blue: 0.52).opacity(0.09))
                    .frame(width: 250, height: 250).blur(radius: 60)
                    .offset(x: -100, y: 220)

                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 12) {
                        BackButton {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                gameState.currentScreen = .selection
                                gameState.resetGame()
                            }
                        }

                        Spacer()

                        // Cat name + happiness
                        VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text(gameState.selectedCat?.emoji ?? "🐱")
                                    .font(.system(size: 15))
                                Text(gameState.selectedCat?.name ?? "")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }

                            HStack(spacing: 8) {
                                HappinessBar(value: gameState.happiness)
                                    .frame(width: 120, height: 8)

                                Text("\(Int(gameState.happiness))%")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(width: 36, alignment: .leading)
                            }
                        }

                        Spacer()
                        // Balance spacer
                        Color.clear.frame(width: 42, height: 42)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)

                    // Cat display area
                    ZStack {
                        if let selectedCat = gameState.selectedCat {
                            RealCatView(
                                imageSource: gameState.getImageForCat(selectedCat),
                                size: 250,
                                isHappy: gameState.happiness > 50,
                                isIdle: true,
                                isBeingPetted: gameState.isBeingPetted,
                                isExcited: gameState.catIsExcited,
                                isZoomedIn: gameState.catZoomedIn
                            )
                            .onTapGesture(coordinateSpace: .local) { location in
                                if gameState.currentMode == .cuddle {
                                    gameState.petCat(at: location)
                                }
                            }
                        }

                        // Floating hearts
                        if gameState.currentMode == .cuddle {
                            ForEach(gameState.hearts) { heart in
                                Text("🐾").font(.title2)
                                    .position(x: heart.x, y: heart.y).opacity(heart.opacity)
                            }
                            ForEach(gameState.sparkles) { sparkle in
                                Text("✨").font(.title3)
                                    .position(x: sparkle.x, y: sparkle.y).opacity(sparkle.opacity)
                            }
                        }

                        // Treats
                        if gameState.currentMode == .treats {
                            ForEach(gameState.treats) { treat in
                                Text("🐟").font(.system(size: 34))
                                    .position(x: treat.x, y: treat.y)
                                    .opacity(treat.opacity).scaleEffect(treat.scale)
                                    .animation(.easeOut(duration: 0.5), value: treat.opacity)
                                    .animation(.easeOut(duration: 0.5), value: treat.scale)
                            }
                        }

                        // Mouse toy
                        if gameState.currentMode == .toys, let mouse = gameState.mouseToy {
                            Text("🐭").font(.system(size: 40))
                                .position(x: mouse.x, y: mouse.y)
                                .rotationEffect(.degrees(mouse.rotation))
                                .animation(.easeInOut(duration: 2.0), value: mouse.x)
                                .animation(.easeInOut(duration: 2.0), value: mouse.y)
                        }

                        // Feeding complete
                        if gameState.showFeedingComplete {
                            VStack(spacing: 10) {
                                Text("😸").font(.system(size: 64))
                                Text("Doydum!")
                                    .font(.system(size: 26, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 28).padding(.vertical, 12)
                                    .background(
                                        LinearGradient(colors: [Color(red: 1, green: 0.38, blue: 0.52), Color(red: 1, green: 0.62, blue: 0.28)],
                                                       startPoint: .leading, endPoint: .trailing)
                                    )
                                    .clipShape(Capsule())
                                    .shadow(color: Color(red: 1, green: 0.38, blue: 0.52).opacity(0.4), radius: 12, x: 0, y: 5)
                            }
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                            .zIndex(100)
                        }

                        // Toys complete
                        if gameState.showToysComplete {
                            VStack(spacing: 10) {
                                Text("🎯").font(.system(size: 64))
                                Text("Yakaladım!")
                                    .font(.system(size: 26, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 28).padding(.vertical, 12)
                                    .background(
                                        LinearGradient(colors: [Color(red: 0.22, green: 0.78, blue: 0.44), Color.mint],
                                                       startPoint: .leading, endPoint: .trailing)
                                    )
                                    .clipShape(Capsule())
                                    .shadow(color: Color.green.opacity(0.4), radius: 12, x: 0, y: 5)
                            }
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                            .zIndex(100)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onChange(of: gameState.currentMode) { newMode in
                        if newMode == .treats {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                gameState.startFeeding(in: geometry.size)
                            }
                        }
                        if newMode == .toys {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                gameState.startPlayingWithToys(in: geometry.size)
                            }
                        }
                    }

                    // Instruction hint
                    Group {
                        switch gameState.currentMode {
                        case .cuddle:
                            Label("Tap \(gameState.selectedCat?.name ?? "your cat") to pet them!", systemImage: "hand.tap.fill")
                        case .treats:
                            Label("Feeding \(gameState.selectedCat?.name ?? "your cat") treats 🐟", systemImage: "fork.knife")
                        case .toys:
                            Label("Chasing the mouse! 🐭", systemImage: "figure.run")
                        }
                    }
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.55))
                    .padding(.bottom, 16)

                    // Bottom Mode Bar
                    HStack(spacing: 8) {
                        ModeTabButton(icon: "🐱", label: "Cuddle", isActive: gameState.currentMode == .cuddle) {
                            gameState.switchMode(to: .cuddle)
                        }
                        ModeTabButton(icon: "🍖", label: "Treats", isActive: gameState.currentMode == .treats) {
                            gameState.switchMode(to: .treats)
                        }
                        ModeTabButton(icon: "⭐", label: "Toys", isActive: gameState.currentMode == .toys) {
                            gameState.switchMode(to: .toys)
                        }
                    }
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.14), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 6)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 36)
                }

                // Celebration overlay
                if gameState.showFullScreenCelebration, let selectedCat = gameState.selectedCat {
                    FullScreenCelebrationView(
                        imageSource: gameState.getImageForCat(selectedCat),
                        catName: selectedCat.name,
                        gameState: gameState
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .zIndex(200)
                }
            }
        }
    }
}

// MARK: - Mode Tab Button
struct ModeTabButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(icon).font(.system(size: 22))
                Text(label)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? .white : .white.opacity(0.45))
            }
            .frame(minWidth: 72, minHeight: 60)
            .background(
                isActive
                    ? AnyView(
                        LinearGradient(
                            colors: [Color(red: 1, green: 0.38, blue: 0.52).opacity(0.55), Color(red: 1, green: 0.58, blue: 0.28).opacity(0.35)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                        .clipShape(Capsule())
                    )
                    : AnyView(Color.clear)
            )
            .scaleEffect(pressed ? 0.93 : (isActive ? 1.0 : 0.97))
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isActive)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.08)) { pressed = true } }
                .onEnded { _ in withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { pressed = false } }
        )
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
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.97)),
                        removal: .opacity.combined(with: .scale(scale: 1.03))
                    ))
            case .selection:
                SelectionScreen(gameState: gameState)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            case .game:
                GameScreen(gameState: gameState)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: gameState.currentScreen)
    }
}

// MARK: - Preview
struct CatCuddleApp_Previews: PreviewProvider {
    static var previews: some View {
        CatCuddleApp()
    }
}
