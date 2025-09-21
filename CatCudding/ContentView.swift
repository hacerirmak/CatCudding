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
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                        .position(x: heart.x, y: heart.y)
                        .opacity(heart.opacity)
                }
                
                ForEach(celebrationSparkles) { sparkle in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
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
            
            // Generate celebration effects
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
import SwiftUI
import AVFoundation
import Combine
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

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
    }
}

enum ScreenType {
    case welcome, selection, game
}

// MARK: - Real Cat Image View
struct RealCatView: View {
    let imageSource: Any? // Can be String (for asset names) or UIImage (for custom photos)
    let size: CGFloat
    let isHappy: Bool
    let isIdle: Bool
    let isBeingPetted: Bool
    
    @State private var idleAnimation = false
    @State private var heartBeat = false
    
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
            .scaleEffect(isBeingPetted ? 1.1 : (idleAnimation ? 1.02 : 1.0))
            .rotationEffect(.degrees(isBeingPetted ? 2 : 0))
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
        }
        .onChange(of: isHappy) { newValue in
            withAnimation {
                heartBeat = newValue
            }
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
                                isBeingPetted: gameState.isBeingPetted
                            )
                            .onTapGesture(coordinateSpace: .local) { location in
                                gameState.petCat(at: location)
                            }
                        }
                        
                        // Floating hearts
                        ForEach(gameState.hearts) { heart in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                                .position(x: heart.x, y: heart.y)
                                .opacity(heart.opacity)
                        }
                        
                        // Floating sparkles
                        ForEach(gameState.sparkles) { sparkle in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.title3)
                                .position(x: sparkle.x, y: sparkle.y)
                                .opacity(sparkle.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Instructions
                    VStack(spacing: 10) {
                        Text("Tap and pet \(gameState.selectedCat?.name ?? "your cat")!")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Watch the happiness meter grow 💖")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 30)
                    
                    // Bottom navigation
                    HStack(spacing: 40) {
                        Button(action: {}) {
                            VStack(spacing: 5) {
                                Text("🐱")
                                    .font(.title2)
                                Text("Cuddle")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.orange)
                            .cornerRadius(25)
                        }
                        
                        Button(action: {}) {
                            VStack(spacing: 5) {
                                Text("🍖")
                                    .font(.title2)
                                Text("Treats")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.orange)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        
                        Button(action: {}) {
                            VStack(spacing: 5) {
                                Text("⭐")
                                    .font(.title2)
                                Text("Toys")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.orange)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
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
