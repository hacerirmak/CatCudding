import SwiftUI
import AVFoundation
import Combine
import CoreMotion

class GameState: ObservableObject {
    // MARK: Navigation
    @Published var currentScreen: ScreenType = .welcome

    // MARK: Cat
    @Published var selectedCat: Cat?
    @Published var customCatImage: UIImage?
    @Published var customCatName = ""
    @Published var customCat: Cat? = nil

    // MARK: Happiness
    @Published var happiness: Double = 0
    @Published var hearts: [FloatingElement] = []
    @Published var sparkles: [FloatingElement] = []
    @Published var isBeingPetted = false
    @Published var showFullScreenCelebration = false

    // MARK: Mode
    @Published var currentMode: GameMode = .cuddle

    // MARK: Cuddle
    @Published var petDragLocation: CGPoint? = nil
    @Published var purrIntensity: Double = 0

    // MARK: Treats
    @Published var draggableTreats: [DraggableTreat] = []
    @Published var showFeedingComplete = false

    // MARK: Toys — Feather Wand
    @Published var wandTiltX: Double = 0
    @Published var wandDescendY: Double = 0
    @Published var catIsExcited = false
    @Published var catZoomedIn = false
    @Published var showCatchEffect = false

    let cats = [
        Cat(name: "Whiskers",      description: "Super playful!",       breed: "Orange Tabby",      color: .orange, emoji: "🧡"),
        Cat(name: "Cloudy Paws",   description: "Gentle giant",          breed: "British Shorthair", color: .gray,   emoji: "🩶"),
        Cat(name: "Shadow Pounce", description: "Mischievous explorer",  breed: "Black Kitten",      color: .black,  emoji: "🖤")
    ]
    let catImages = ["cat1", "cat2", "cat3"]

    private var purrDecay: AnyCancellable?
    private var lastPetTime: Date = .distantPast
    private let motionManager = CMMotionManager()
    private var wandDescentTimer: AnyCancellable?
    private var wandSwingTimer: AnyCancellable?
    private var catchWork: DispatchWorkItem?

    // MARK: - Cat

    func selectCat(_ cat: Cat) { selectedCat = cat }

    func getImageForCat(_ cat: Cat) -> Any? {
        if cat.isCustom { return customCatImage }
        if let i = cats.firstIndex(of: cat) { return catImages[i] }
        return nil
    }

    func addCustomCat(image: UIImage, name: String) {
        BackgroundRemovalService.removeBackground(from: image) { processed in
            DispatchQueue.main.async {
                let resolvedName = name.isEmpty ? "My Cat" : name
                self.customCatImage = processed ?? image
                self.customCatName = resolvedName
                self.customCat = Cat(
                    name: resolvedName,
                    description: "My special friend!",
                    breed: "Custom Cat",
                    color: .purple,
                    emoji: "💜",
                    isCustom: true
                )
            }
        }
    }

    // MARK: - Cuddle

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

    // MARK: - Treats

    func setupTreats(in size: CGSize) {
        guard draggableTreats.isEmpty else { return }
        let types: [TreatType] = [.fish, .meat, .shrimp, .tuna, .chicken]
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
            draggableTreats[i].isEaten = true
            draggableTreats[i].scale = 1.7
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.3)) {
                guard i < self.draggableTreats.count else { return }
                self.draggableTreats[i].opacity = 0
                self.draggableTreats[i].scale = 0.1
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

    // MARK: - Toys — Feather Wand

    func startWand() {
        wandDescendY = 0
        wandTiltX = 0
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 30
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
                guard let data = data else { return }
                withAnimation(.interpolatingSpring(stiffness: 140, damping: 20)) {
                    self?.wandTiltX = max(-1, min(1, data.acceleration.x * 1.8))
                }
            }
        } else {
            var dir = 1.0
            wandSwingTimer = Timer.publish(every: 0.04, on: .main, in: .common).autoconnect()
                .sink { [weak self] _ in
                    guard let self = self, self.currentMode == .toys else { return }
                    self.wandTiltX = max(-0.75, min(0.75, self.wandTiltX + dir * 0.018))
                    if abs(self.wandTiltX) >= 0.75 { dir *= -1 }
                }
        }
        startWandDescent()
    }

    private func startWandDescent() {
        wandDescentTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.currentMode == .toys else { return }
                self.wandDescendY = min(1.0, self.wandDescendY + 0.004)
                let inReach = self.wandDescendY > 0.60
                if inReach != self.catIsExcited { self.catIsExcited = inReach }
                if inReach && self.catchWork == nil {
                    let work = DispatchWorkItem { [weak self] in self?.catCatchWand() }
                    self.catchWork = work
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: work)
                } else if !inReach {
                    self.catchWork?.cancel()
                    self.catchWork = nil
                }
            }
    }

    private func catCatchWand() {
        guard currentMode == .toys else { return }
        catchWork = nil
        AudioServicesPlaySystemSound(1105)
        showCatchEffect = true
        withAnimation(.spring(response: 0.20, dampingFraction: 0.42)) { catZoomedIn = true }
        withAnimation(.easeInOut(duration: 0.28)) { happiness = min(happiness + 20, 100) }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.55)) { wandDescendY = 0 }
        catIsExcited = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.7)) { self.catZoomedIn = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation { self.showCatchEffect = false }
            if self.happiness >= 100 {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { self.showFullScreenCelebration = true }
            }
        }
    }

    func stopWand() {
        motionManager.stopAccelerometerUpdates()
        wandSwingTimer?.cancel()
        wandDescentTimer?.cancel()
        catchWork?.cancel()
        catchWork = nil
        wandTiltX = 0
        wandDescendY = 0
        catIsExcited = false
        catZoomedIn = false
        showCatchEffect = false
    }

    // MARK: - Mode / Reset

    func switchMode(to newMode: GameMode) {
        guard newMode != currentMode else { return }
        cleanupCurrentMode()
        withAnimation(.easeOut(duration: 0.3)) { happiness = 0 }
        showFullScreenCelebration = false
        currentMode = newMode
    }

    private func cleanupCurrentMode() {
        hearts.removeAll()
        sparkles.removeAll()
        isBeingPetted = false
        petDragLocation = nil
        purrIntensity = 0
        purrDecay?.cancel()
        draggableTreats.removeAll()
        showFeedingComplete = false
        stopWand()
    }

    func resetGame() {
        happiness = 0
        showFullScreenCelebration = false
        cleanupCurrentMode()
        currentMode = .cuddle
    }

    // MARK: - Particles

    func generateHearts(at location: CGPoint) {
        let batch = (0..<3).map { _ in
            FloatingElement(x: location.x + .random(in: -40...40), y: location.y + .random(in: -20...20))
        }
        hearts.append(contentsOf: batch)
        for (i, h) in batch.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                withAnimation(.easeOut(duration: 1.8)) {
                    if let idx = self.hearts.firstIndex(where: { $0.id == h.id }) {
                        self.hearts[idx] = FloatingElement(x: h.x + .random(in: -30...30), y: h.y - 90, opacity: 0)
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
        let s = FloatingElement(x: location.x + .random(in: -25...25), y: location.y + .random(in: -25...25))
        sparkles.append(s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
            withAnimation(.easeInOut(duration: 0.9)) {
                if let idx = self.sparkles.firstIndex(where: { $0.id == s.id }) {
                    self.sparkles[idx] = FloatingElement(x: s.x + .random(in: -40...40), y: s.y - 55, opacity: 0)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.sparkles.removeAll { $0.id == s.id }
        }
    }
}
