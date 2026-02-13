// MARK: - Full Screen Celebration View
import SwiftUI
import AVFoundation
import Combine
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

// MARK: - Full Screen Celebration View
struct FullScreenCelebrationView: View {
    let imageSource: Any?
    let catName: String
    @ObservedObject var gameState: GameState
    
    @State private var celebrationHearts: [FloatingElement] = []
    @State private var celebrationSparkles: [FloatingElement] = []
    @State private var confettiAnimation = false
    @State private var titleAnimation = false
    @State private var catImageScale: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Rainbow background
                LinearGradient(
                    colors: [
                        Color.pink.opacity(0.8),
                        Color.purple.opacity(0.8),
                        Color.blue.opacity(0.8),
                        Color.green.opacity(0.8),
                        Color.yellow.opacity(0.8),
                        Color.orange.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .hueRotation(.degrees(confettiAnimation ? 360 : 0))
                .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: confettiAnimation)
                
                // Floating celebration elements
                ForEach(celebrationHearts) { heart in
                    Text("🐾")
                        .font(.system(size: 30))
                        .position(x: heart.x, y: heart.y)
                        .opacity(heart.opacity)
                }
                
                ForEach(celebrationSparkles) { sparkle in
                    Text("🐾")
                        .font(.system(size: 25))
                        .position(x: sparkle.x, y: sparkle.y)
                        .opacity(sparkle.opacity)
                }
                
                VStack(spacing: 30) {
                    // Celebration title
                    VStack(spacing: 10) {
                        Text("🎉 AMAZING! 🎉")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .scaleEffect(titleAnimation ? 1.2 : 1.0)
                            .animation(.spring(response: 0.5).repeatForever(autoreverses: true), value: titleAnimation)
                        
                        Text("\(catName) is super happy!")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                    
                    // Full screen cat image
                    Group {
                        if let imageName = imageSource as? String {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if let uiImage = imageSource as? UIImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(
                                    // Add a subtle gradient background for transparent images
                                    LinearGradient(
                                        colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Text("🐱")
                                        .font(.system(size: 100))
                                )
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.8, maxHeight: geometry.size.height * 0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .scaleEffect(catImageScale)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    colors: [.pink, .yellow, .green, .blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 8
                            )
                            .hueRotation(.degrees(confettiAnimation ? 360 : 0))
                    )
                    .shadow(color: .white.opacity(0.8), radius: 20, x: 0, y: 0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: catImageScale)
                    
                    Spacer()
                    
                    // Celebration message
                    VStack(spacing: 15) {
                        Text("💖 Perfect Happiness Achieved! 💖")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("You've made \(catName) the happiest cat ever!")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Continue button
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            gameState.showFullScreenCelebration = false
                            // Reset happiness to start over
                            gameState.happiness = 0
                        }
                    }) {
                        Text("Continue Playing")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.purple)
                            .frame(width: 250, height: 60)
                            .background(
                                LinearGradient(
                                    colors: [Color.white, Color.yellow.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .scaleEffect(titleAnimation ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: titleAnimation)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            // Start animations
            withAnimation {
                confettiAnimation = true
                titleAnimation = true
                catImageScale = 1.0
            }
            
            // Generate celebration effects using screen size
            generateCelebrationEffects(in: UIScreen.main.bounds.size)
        }
    }
    
    private func generateCelebrationEffects(in size: CGSize) {
        // Generate lots of hearts and sparkles
        let heartCount = 20
        let sparkleCount = 30
        
        for i in 0..<heartCount {
            let heart = FloatingElement(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            celebrationHearts.append(heart)
            
            // Animate hearts
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                withAnimation(.easeOut(duration: 3.0)) {
                    if let index = celebrationHearts.firstIndex(where: { $0.id == heart.id }) {
                        celebrationHearts[index] = FloatingElement(
                            x: heart.x + CGFloat.random(in: -100...100),
                            y: heart.y - 200,
                            opacity: 0
                        )
                    }
                }
            }
        }
        
        for i in 0..<sparkleCount {
            let sparkle = FloatingElement(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            celebrationSparkles.append(sparkle)
            
            // Animate sparkles
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    if let index = celebrationSparkles.firstIndex(where: { $0.id == sparkle.id }) {
                        celebrationSparkles[index] = FloatingElement(
                            x: sparkle.x + CGFloat.random(in: -150...150),
                            y: sparkle.y - 150,
                            opacity: 0
                        )
                    }
                }
            }
        }
        
        // Clean up after animations
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
    
    // Equatable conformance
    static func == (lhs: Cat, rhs: Cat) -> Bool {
        return lhs.id == rhs.id
    }
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
    
    // Game mode
    @Published var currentMode: GameMode = .cuddle
    
    // Treats feature
    @Published var treats: [Treat] = []
    @Published var isFeeding: Bool = false
    @Published var showFeedingComplete: Bool = false
    @Published var isTreatsButtonDisabled: Bool = false
    
    // Toys feature
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
        return Cat(
            name: customCatName.isEmpty ? "My Cat" : customCatName,
            description: "My special friend!",
            breed: "Custom Cat",
            color: .purple,
            emoji: "💜",
            isCustom: true
        )
    }
    
    var allCats: [Cat] {
        var allCats = cats
        if let custom = customCat {
            allCats.append(custom)
        }
        return allCats
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    func selectCat(_ cat: Cat) {
        selectedCat = cat
    }
    
    func addCustomCat(image: UIImage, name: String) {
        // Process image to remove background
        removeBackground(from: image) { processedImage in
            DispatchQueue.main.async {
                self.customCatImage = processedImage ?? image // Fallback to original if processing fails
                self.customCatName = name.isEmpty ? "My Cat" : name
            }
        }
    }
    
    private func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        // Fix orientation first by redrawing the image
        let fixedImage = fixImageOrientation(image)
        
        guard let inputImage = CIImage(image: fixedImage) else {
            completion(nil)
            return
        }
        
        // Create a request to detect salient objects
        let request = VNGenerateForegroundInstanceMaskRequest { request, error in
            guard error == nil,
                  let results = request.results as? [VNInstanceMaskObservation],
                  let result = results.first else {
                completion(nil)
                return
            }
            
            do {
                // Create mask from the detection result
                let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: VNImageRequestHandler(ciImage: inputImage))
                let maskImage = CIImage(cvPixelBuffer: maskPixelBuffer)
                
                // Create background removal filter
                let filter = CIFilter.blendWithMask()
                filter.inputImage = inputImage
                filter.backgroundImage = CIImage.empty()
                filter.maskImage = maskImage
                
                // Render the result
                let context = CIContext()
                if let outputImage = filter.outputImage,
                   let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    // Create UIImage with correct orientation
                    let processedImage = UIImage(cgImage: cgImage, scale: fixedImage.scale, orientation: .up)
                    completion(processedImage)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error processing mask: \(error)")
                completion(nil)
            }
        }
        
        // Perform the request
        let handler = VNImageRequestHandler(ciImage: inputImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error performing vision request: \(error)")
                completion(nil)
            }
        }
    }
    
    private func fixImageOrientation(_ image: UIImage) -> UIImage {
        // If image is already in correct orientation, return as is
        if image.imageOrientation == .up {
            return image
        }
        
        // Create a new image with correct orientation
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fixedImage ?? image
    }
    
    func getImageForCat(_ cat: Cat) -> Any? {
        if cat.isCustom {
            return customCatImage
        } else if let index = cats.firstIndex(of: cat) {
            return catImages[index]
        }
        return nil
    }
    
    func petCat(at location: CGPoint) {
        withAnimation(.easeOut(duration: 0.5)) {
            isBeingPetted = true
            happiness = min(happiness + 10, 100)
            
            // Check if we reached 100% happiness
            if happiness >= 100 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        self.showFullScreenCelebration = true
                    }
                }
            }
        }
        
        generateHearts(at: location)
        generateSparkles(at: location)
        playPurrSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                self.isBeingPetted = false
            }
        }
    }
    
    private func generateHearts(at location: CGPoint) {
        let newHearts = (0..<3).map { i in
            FloatingElement(
                x: location.x + CGFloat.random(in: -50...50),
                y: location.y + CGFloat.random(in: -25...25)
            )
        }
        
        hearts.append(contentsOf: newHearts)
        
        // Animate hearts floating up
        for (index, heart) in newHearts.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                withAnimation(.easeOut(duration: 2.0)) {
                    if let heartIndex = self.hearts.firstIndex(where: { $0.id == heart.id }) {
                        self.hearts[heartIndex] = FloatingElement(
                            x: heart.x,
                            y: heart.y - 60,
                            opacity: 0
                        )
                    }
                }
            }
        }
        
        // Remove hearts after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hearts.removeAll { heart in
                newHearts.contains { $0.id == heart.id }
            }
        }
    }
    
    private func generateSparkles(at location: CGPoint) {
        let newSparkles = (0..<5).map { i in
            FloatingElement(
                x: location.x + CGFloat.random(in: -60...60),
                y: location.y + CGFloat.random(in: -40...40)
            )
        }
        
        sparkles.append(contentsOf: newSparkles)
        
        // Animate sparkles twinkling
        for (index, sparkle) in newSparkles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    if let sparkleIndex = self.sparkles.firstIndex(where: { $0.id == sparkle.id }) {
                        self.sparkles[sparkleIndex] = FloatingElement(
                            x: sparkle.x,
                            y: sparkle.y,
                            opacity: 0
                        )
                    }
                }
            }
        }
        
        // Remove sparkles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.sparkles.removeAll { sparkle in
                newSparkles.contains { $0.id == sparkle.id }
            }
        }
    }
    
    private func playPurrSound() {
        // In a real app, you would load and play an actual purr sound file
        // For demonstration, we'll use system sound
        AudioServicesPlaySystemSound(1104) // Camera shutter sound as placeholder
        print("Mrrr... 🐱") // Console feedback
    }
    
    func resetGame() {
        happiness = 0
        hearts.removeAll()
        sparkles.removeAll()
        isBeingPetted = false
        showFullScreenCelebration = false
        
        // Reset treats
        treats.removeAll()
        isFeeding = false
        showFeedingComplete = false
        isTreatsButtonDisabled = false
        
        // Reset toys
        mouseToy = nil
        isPlayingWithToy = false
        catIsExcited = false
        catZoomedIn = false
        showToysComplete = false
        
        // Reset to cuddle mode
        currentMode = .cuddle
    }
    
    // MARK: - Mode Switching
    func switchMode(to newMode: GameMode) {
        guard newMode != currentMode else { return }
        
        // Clean up current mode
        switch currentMode {
        case .cuddle:
            hearts.removeAll()
            sparkles.removeAll()
            isBeingPetted = false
        case .treats:
            treats.removeAll()
            isFeeding = false
            showFeedingComplete = false
            isTreatsButtonDisabled = false
        case .toys:
            mouseToy = nil
            isPlayingWithToy = false
            catIsExcited = false
            catZoomedIn = false
            showToysComplete = false
        }
        
        // Reset happiness and celebration
        withAnimation(.easeOut(duration: 0.3)) {
            happiness = 0
        }
        showFullScreenCelebration = false
        
        // Switch to new mode
        currentMode = newMode
    }
    
    // MARK: - Treats Feature
    func startFeeding(in size: CGSize) {
        guard !isFeeding && currentMode == .treats else { return }
        
        isFeeding = true
        isTreatsButtonDisabled = true
        
        // Generate 8 fish treats around the cat
        let treatCount = 8
        let centerX = size.width / 2
        let centerY = size.height / 2
        let radius: CGFloat = 120
        
        for i in 0..<treatCount {
            let angle = (CGFloat(i) / CGFloat(treatCount)) * 2 * .pi
            let x = centerX + cos(angle) * radius
            let y = centerY + sin(angle) * radius
            
            let treat = Treat(x: x, y: y)
            treats.append(treat)
        }
        
        // Start eating treats one by one
        eatNextTreat()
    }
    
    private func eatNextTreat() {
        // Check if we're still in treats mode and have treats
        guard currentMode == .treats, !treats.isEmpty else {
            return
        }
        
        // Find the next uneaten treat
        guard let nextTreatIndex = treats.firstIndex(where: { !$0.isEaten }) else {
            // All treats eaten, complete the feeding
            completeFeedingSession()
            return
        }
        
        // Mark as being eaten
        treats[nextTreatIndex].isEaten = true
        
        // Animate treat disappearing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, self.currentMode == .treats, nextTreatIndex < self.treats.count else {
                return
            }
            
            withAnimation(.easeOut(duration: 0.5)) {
                self.treats[nextTreatIndex].opacity = 0
                self.treats[nextTreatIndex].scale = 0.5
            }
            
            // Update happiness progress (using existing happiness meter)
            let progressIncrement = 100.0 / Double(self.treats.count)
            withAnimation(.easeInOut(duration: 0.3)) {
                self.happiness = min(self.happiness + progressIncrement, 100)
            }
            
            // Play sound effect
            AudioServicesPlaySystemSound(1103)
            
            // Continue to next treat
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.eatNextTreat()
            }
        }
    }
    
    private func completeFeedingSession() {
        // Check if we're still in treats mode
        guard currentMode == .treats else {
            return
        }
        
        // Show completion message
        withAnimation {
            showFeedingComplete = true
        }
        
        // Check if happiness reached 100%
        if happiness >= 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self, self.currentMode == .treats else { return }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    self.showFullScreenCelebration = true
                }
            }
        }
        
        // Hide message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.showFeedingComplete = false
            }
            
            // Clean up and reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.treats.removeAll()
                self.isFeeding = false
                self.isTreatsButtonDisabled = false
            }
        }
    }
    
    // MARK: - Toys Feature
    func startPlayingWithToys(in size: CGSize) {
        guard !isPlayingWithToy && currentMode == .toys else { return }
        
        isPlayingWithToy = true
        catIsExcited = true
        
        // Spawn mouse at top-left corner (safe area)
        mouseToy = MouseToy(x: 80, y: 80)
        
        // Start mouse movement animation
        animateMouseMovement(in: size)
        
        // Start progress increase (8 seconds to 100%)
        startProgressTimer()
    }
    
    private func animateMouseMovement(in size: CGSize) {
        guard currentMode == .toys, let mouse = mouseToy else { return }
        
        // Larger padding to keep mouse visible
        let padding: CGFloat = 80
        let waypoints: [(x: CGFloat, y: CGFloat, rotation: Double)] = [
            (padding, padding, 0),                          // Top-left
            (size.width - padding, padding, 0),             // Top-right
            (size.width - padding, size.height - 200, 180), // Bottom-right (avoid bottom bar)
            (padding, size.height - 200, 180),              // Bottom-left (avoid bottom bar)
        ]
        
        animateToNextWaypoint(waypoints: waypoints, currentIndex: 0, in: size)
    }
    
    private func animateToNextWaypoint(waypoints: [(x: CGFloat, y: CGFloat, rotation: Double)], currentIndex: Int, in size: CGSize) {
        guard currentMode == .toys, mouseToy != nil else { return }
        
        let nextIndex = (currentIndex + 1) % waypoints.count
        let waypoint = waypoints[nextIndex]
        
        withAnimation(.easeInOut(duration: 2.0)) {
            mouseToy?.x = waypoint.x
            mouseToy?.y = waypoint.y
            mouseToy?.rotation = waypoint.rotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.animateToNextWaypoint(waypoints: waypoints, currentIndex: nextIndex, in: size)
        }
    }
    
    private func startProgressTimer() {
        let totalDuration: Double = 8.0 // 8 seconds
        let steps = 80 // 80 steps = smooth animation
        let increment = 100.0 / Double(steps)
        let stepDuration = totalDuration / Double(steps)
        
        for i in 0..<steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * stepDuration) { [weak self] in
                guard let self = self, self.currentMode == .toys else { return }
                
                withAnimation(.linear(duration: stepDuration)) {
                    self.happiness = min(self.happiness + increment, 100)
                }
                
                // Check if completed
                if self.happiness >= 100 {
                    self.completeToysSession()
                }
            }
        }
    }
    
    private func completeToysSession() {
        guard currentMode == .toys else { return }
        
        // Stop cat excitement
        catIsExcited = false
        
        // Hide mouse
        withAnimation(.easeOut(duration: 0.5)) {
            mouseToy = nil
        }
        
        // Zoom in cat
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, self.currentMode == .toys else { return }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                self.catZoomedIn = true
            }
            
            // Show completion message
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                withAnimation {
                    self.showToysComplete = true
                }
                
                // Check if should show celebration
                if self.happiness >= 100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                        guard let self = self, self.currentMode == .toys else { return }
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            self.showFullScreenCelebration = true
                        }
                    }
                }
                
                // Hide completion message and reset
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else { return }
                    withAnimation {
                        self.showToysComplete = false
                        self.catZoomedIn = false
                    }
                    
                    self.isPlayingWithToy = false
                }
            }
        }
    }
}

enum ScreenType {
    case welcome, selection, game
}

enum GameMode {
    case cuddle, treats, toys
}

// MARK: - Real Cat Image View
struct RealCatView: View {
    let imageSource: Any? // Can be String (for asset names) or UIImage (for custom photos)
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
            // Main cat image
            Group {
                if let imageName = imageSource as? String {
                    // Asset image
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if let uiImage = imageSource as? UIImage {
                    // Custom user image
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    // Fallback
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Text("🐱")
                                .font(.system(size: size * 0.3))
                        )
                }
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(
                isZoomedIn ? 1.35 : (isBeingPetted ? 1.1 : (idleAnimation ? 1.02 : 1.0))
            )
            .rotationEffect(.degrees(isBeingPetted ? 2 : (isExcited ? shakeOffset * 2 : 0)))
            .offset(
                x: isExcited ? shakeOffset : 0,
                y: isZoomedIn ? -30 : 0
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            .overlay(
                // Happy glow effect
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isHappy ?
                        LinearGradient(colors: [.pink, .yellow, .pink], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.clear], startPoint: .top, endPoint: .bottom),
                        lineWidth: isHappy ? 4 : 0
                    )
                    .opacity(isHappy ? (heartBeat ? 1.0 : 0.6) : 0)
            )
            .animation(.spring(response: 0.3), value: isBeingPetted)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: idleAnimation)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: heartBeat)
            
            // Happy face overlay when very happy
            if isHappy {
                VStack {
                    HStack(spacing: 8) {
                        Text("😊")
                            .font(.title)
                        Text("💖")
                            .font(.title2)
                    }
                    .scaleEffect(heartBeat ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: heartBeat)
                }
                .offset(y: -size * 0.4)
            }
        }
        .onAppear {
            if isIdle {
                withAnimation {
                    idleAnimation = true
                }
            }
            if isHappy {
                withAnimation {
                    heartBeat = true
                }
            }
            if isExcited {
                startShakeAnimation()
            }
        }
        .onChange(of: isHappy) { newValue in
            withAnimation {
                heartBeat = newValue
            }
        }
        .onChange(of: isExcited) { newValue in
            if newValue {
                startShakeAnimation()
            } else {
                shakeOffset = 0
            }
        }
    }
    
    private func startShakeAnimation() {
        withAnimation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) {
            shakeOffset = 3
        }
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
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        return path
    }
}

// MARK: - Welcome Screen
struct WelcomeScreen: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.orange.opacity(0.3), Color.pink.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Decorative paw prints
                VStack {
                    HStack {
                        Text("🐾")
                            .font(.title)
                            .foregroundColor(.gray.opacity(0.3))
                            .rotationEffect(.degrees(12))
                            .offset(x: -geometry.size.width * 0.3, y: geometry.size.height * 0.1)
                        
                        Spacer()
                        
                        Text("🐾")
                            .font(.largeTitle)
                            .foregroundColor(.gray.opacity(0.3))
                            .rotationEffect(.degrees(-12))
                            .offset(x: geometry.size.width * 0.2, y: geometry.size.height * 0.2)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("🐾")
                            .font(.title)
                            .foregroundColor(.gray.opacity(0.3))
                            .rotationEffect(.degrees(45))
                            .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.2)
                        
                        Spacer()
                        
                        Text("🐾")
                            .font(.title)
                            .foregroundColor(.gray.opacity(0.3))
                            .rotationEffect(.degrees(-45))
                            .offset(x: geometry.size.width * 0.2, y: -geometry.size.height * 0.3)
                    }
                }
            
                VStack(spacing: 30) {
                    // Logo
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.orange.opacity(0.7), Color.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.orange, Color.orange.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 90, height: 90)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                        
                        Text("🐱")
                            .font(.largeTitle)
                    }
                    
                    // Title
                    Text("Cat Cuddle")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                    
                    // Subtitle
                    Text("Tap the button to start cuddling some cute kittens!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    // Play button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            gameState.currentScreen = .selection
                        }
                    }) {
                        Text("Play Now")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(30)
                            .shadow(radius: 5)
                    }
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.1), value: gameState.currentScreen)
                    
                    Spacer()
                    
                    Text("Copyright 2024")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
    }
}

// MARK: - Cat Selection Screen
struct SelectionScreen: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.pink.opacity(0.3), Color.orange.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            gameState.currentScreen = .welcome
                        }
                    }) {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Title
                VStack(alignment: .leading, spacing: 5) {
                    Text("Choose Your Cat")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("Find your purrfect pal!")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Cat options
                VStack(spacing: 15) {
                    // Default cats
                    ForEach(Array(gameState.cats.enumerated()), id: \.element.id) { index, cat in
                        CatSelectionCard(
                            cat: cat,
                            imageSource: gameState.catImages[index],
                            isSelected: gameState.selectedCat?.id == cat.id
                        ) {
                            withAnimation(.spring()) {
                                gameState.selectCat(cat)
                            }
                        }
                    }
                    
                    // Custom cat (if added)
                    if let customCat = gameState.customCat {
                        CatSelectionCard(
                            cat: customCat,
                            imageSource: gameState.customCatImage,
                            isSelected: gameState.selectedCat?.id == customCat.id
                        ) {
                            withAnimation(.spring()) {
                                gameState.selectCat(customCat)
                            }
                        }
                    }
                    
                    // Add custom cat option
                    AddCustomCatCard(gameState: gameState)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Start button
                Button(action: {
                    if gameState.selectedCat != nil {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            gameState.currentScreen = .game
                        }
                    }
                }) {
                    Text("Let's Cuddle!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(
                            gameState.selectedCat != nil ?
                            LinearGradient(
                                colors: [Color.red, Color.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [Color.gray, Color.gray],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(30)
                        .shadow(radius: gameState.selectedCat != nil ? 5 : 0)
                }
                .disabled(gameState.selectedCat == nil)
                .padding(.horizontal)
                .padding(.bottom, 30)
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
        VStack(spacing: 15) {
            // Photo picker button
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
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 60, height: 60)
                        
                        if isProcessingImage {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                .scaleEffect(1.5)
                        } else {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.purple)
                        }
                    }
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.purple, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    
                    VStack(spacing: 2) {
                        Text("Add Your Cat")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        
                        Text(isProcessingImage ? "Processing image..." : "Upload your own photo!")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isProcessingImage)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.5), Color.blue.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 2, dash: [5])
                )
        )
        .alert("Name Your Cat", isPresented: $showingNameAlert) {
            TextField("Enter cat name", text: $tempCatName)
            Button("Add Cat") {
                if let image = selectedImage {
                    isProcessingImage = true
                    gameState.addCustomCat(image: image, name: tempCatName)
                    
                    // Reset after a delay to show processing
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        tempCatName = ""
                        selectedImage = nil
                        isProcessingImage = false
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                tempCatName = ""
                selectedImage = nil
            }
        } message: {
            Text("Give your cat a special name! We'll automatically remove the background to make your cat look amazing in the game.")
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
            HStack(spacing: 15) {
                // Cat preview
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Group {
                            if let imageName = imageSource as? String {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else if let uiImage = imageSource as? UIImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Text(cat.emoji)
                                    .font(.title2)
                            }
                        }
                    )
                    .overlay(
                        Circle()
                            .stroke(cat.isCustom ? Color.purple : Color.yellow, lineWidth: 4)
                    )
                
                // Cat info
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(cat.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(cat.isCustom ? .purple : .red)
                        
                        if cat.isCustom {
                            Text("💜")
                                .font(.caption)
                        }
                    }
                    
                    Text(cat.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.title3)
                        )
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: isSelected ? 10 : 5)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Game Screen
struct GameScreen: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.indigo.opacity(0.8), Color.purple.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                gameState.currentScreen = .selection
                                gameState.resetGame()
                            }
                        }) {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                )
                        }
                        
                        Spacer()
                        
                        // Cat info and happiness meter
                        VStack(spacing: 5) {
                            Text(gameState.selectedCat?.name ?? "")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 10) {
                                ProgressView(value: gameState.happiness, total: 100)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .pink))
                                    .frame(width: 120, height: 8)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(4)
                                
                                Text("\(Int(gameState.happiness))%")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
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
                                // Only allow petting in cuddle mode
                                if gameState.currentMode == .cuddle {
                                    gameState.petCat(at: location)
                                }
                            }
                        }
                        
                        // Floating hearts (only in cuddle mode)
                        if gameState.currentMode == .cuddle {
                            ForEach(gameState.hearts) { heart in
                                Text("🐾")
                                    .font(.title2)
                                    .position(x: heart.x, y: heart.y)
                                    .opacity(heart.opacity)
                            }
                            
                            ForEach(gameState.sparkles) { sparkle in
                                Text("🐾")
                                    .font(.title3)
                                    .position(x: sparkle.x, y: sparkle.y)
                                    .opacity(sparkle.opacity)
                            }
                        }
                        
                        // Treats (Fish) - only in treats mode
                        if gameState.currentMode == .treats {
                            ForEach(gameState.treats) { treat in
                                Text("🐟")
                                    .font(.system(size: 35))
                                    .position(x: treat.x, y: treat.y)
                                    .opacity(treat.opacity)
                                    .scaleEffect(treat.scale)
                                    .animation(.easeOut(duration: 0.5), value: treat.opacity)
                                    .animation(.easeOut(duration: 0.5), value: treat.scale)
                            }
                        }
                        
                        // Mouse Toy - only in toys mode
                        if gameState.currentMode == .toys, let mouse = gameState.mouseToy {
                            Text("🐭")
                                .font(.system(size: 40))
                                .position(x: mouse.x, y: mouse.y)
                                .rotationEffect(.degrees(mouse.rotation))
                                .animation(.easeInOut(duration: 2.0), value: mouse.x)
                                .animation(.easeInOut(duration: 2.0), value: mouse.y)
                        }
                        
                        // Feeding Complete Message
                        if gameState.showFeedingComplete {
                            VStack(spacing: 15) {
                                Text("😸")
                                    .font(.system(size: 80))
                                
                                Text("Doydum!")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.orange, Color.pink],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(100)
                        }
                        
                        // Toys Complete Message
                        if gameState.showToysComplete {
                            VStack(spacing: 15) {
                                Text("🎯")
                                    .font(.system(size: 80))
                                
                                Text("Yakaladım!")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.green, Color.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(100)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onChange(of: gameState.currentMode) { newMode in
                        // Auto-start feeding when switching to treats mode
                        if newMode == .treats {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                gameState.startFeeding(in: geometry.size)
                            }
                        }
                        // Auto-start toys when switching to toys mode
                        if newMode == .toys {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                gameState.startPlayingWithToys(in: geometry.size)
                            }
                        }
                    }
                    
                    // Instructions
                    VStack(spacing: 10) {
                        if gameState.currentMode == .cuddle {
                            Text("Tap and pet \(gameState.selectedCat?.name ?? "your cat")!")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Watch the happiness meter grow 💖")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        } else if gameState.currentMode == .treats {
                            Text("Feeding \(gameState.selectedCat?.name ?? "your cat")!")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Watch them eat delicious treats 🐟")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        } else if gameState.currentMode == .toys {
                            Text("Playing with \(gameState.selectedCat?.name ?? "your cat")!")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Watch them chase the mouse! 🐭")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Bottom navigation with Primary/Secondary hierarchy
                    HStack(spacing: 15) {
                        // Secondary Action - Cuddle
                        Button(action: {
                            gameState.switchMode(to: .cuddle)
                        }) {
                            VStack(spacing: 5) {
                                Text("🐱")
                                    .font(.title2)
                                Text("Cuddle")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(gameState.currentMode == .cuddle ? .white : .orange.opacity(0.8))
                            .frame(width: 90, height: 70)
                            .background(gameState.currentMode == .cuddle ? Color.orange.opacity(0.7) : Color.clear)
                            .cornerRadius(20)
                        }
                        
                        // Secondary Action - Treats
                        Button(action: {
                            gameState.switchMode(to: .treats)
                        }) {
                            VStack(spacing: 5) {
                                Text("🍖")
                                    .font(.title2)
                                Text("Treats")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(gameState.currentMode == .treats ? .white : .orange.opacity(0.8))
                            .frame(width: 90, height: 70)
                            .background(gameState.currentMode == .treats ? Color.orange.opacity(0.7) : Color.clear)
                            .cornerRadius(20)
                        }
                        
                        // Primary Action - Toys (Same size but more prominent)
                        Button(action: {
                            gameState.switchMode(to: .toys)
                        }) {
                            VStack(spacing: 5) {
                                Text("⭐")
                                    .font(.title2)
                                Text("Toys")
                                    .font(.caption)
                                    .fontWeight(.black)
                            }
                            .foregroundColor(.white)
                            .frame(width: 90, height: 70)
                            .background(
                                LinearGradient(
                                    colors: gameState.currentMode == .toys ? 
                                        [Color.green, Color.blue] : 
                                        [Color.orange, Color.pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: gameState.currentMode == .toys ? 
                                Color.blue.opacity(0.5) : Color.orange.opacity(0.3), 
                                radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                
                // Full Screen Celebration Overlay
                if gameState.showFullScreenCelebration,
                   let selectedCat = gameState.selectedCat {
                    FullScreenCelebrationView(
                        imageSource: gameState.getImageForCat(selectedCat),
                        catName: selectedCat.name,
                        gameState: gameState
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
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
            case .selection:
                SelectionScreen(gameState: gameState)
            case .game:
                GameScreen(gameState: gameState)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: gameState.currentScreen)
    }
}

// MARK: - Preview
struct CatCuddleApp_Previews: PreviewProvider {
    static var previews: some View {
        CatCuddleApp()
            .preferredColorScheme(.light)
    }
}
