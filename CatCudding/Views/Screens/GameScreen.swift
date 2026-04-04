import SwiftUI

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
            let wandX = catCenter.x + CGFloat(gameState.wandTiltX) * catCenter.x * 0.76
            return max(-20, min(20, (wandX - catCenter.x) * 0.10))
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppBackground()
                AmbientGlow()

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
                        VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text(gameState.selectedCat?.emoji ?? "🐱").font(.system(size: 15))
                                Text(gameState.selectedCat?.name ?? "")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            HStack(spacing: 8) {
                                HappinessBar(value: gameState.happiness).frame(width: 120, height: 8)
                                Text("\(Int(gameState.happiness))%")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(width: 36, alignment: .leading)
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
                            if gameState.currentMode == .cuddle && gameState.purrIntensity > 0.05 {
                                PurrWaveView(intensity: gameState.purrIntensity)
                                    .position(catCenter)
                            }

                            if let cat = gameState.selectedCat {
                                RealCatView(
                                    imageSource: gameState.getImageForCat(cat),
                                    size: 240,
                                    isHappy: gameState.happiness > 50,
                                    isIdle: true,
                                    isBeingPetted: gameState.isBeingPetted,
                                    isExcited: gameState.catIsExcited,
                                    isZoomedIn: gameState.catZoomedIn,
                                    headAngle: catHeadAngle(catCenter: catCenter)
                                )
                                .position(catCenter)
                            }

                            if gameState.currentMode == .cuddle {
                                ForEach(gameState.hearts) { h in
                                    Text("🐾").font(.title2).position(x: h.x, y: h.y).opacity(h.opacity)
                                }
                                ForEach(gameState.sparkles) { s in
                                    Text("✨").font(.title3).position(x: s.x, y: s.y).opacity(s.opacity)
                                }
                            }

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

                            if gameState.currentMode == .toys {
                                let attachPoint = CGPoint(x: playGeo.size.width / 2, y: 0)
                                let tipX = playGeo.size.width / 2 + CGFloat(gameState.wandTiltX) * playGeo.size.width * 0.38
                                let tipY = playGeo.size.height * 0.06 + CGFloat(gameState.wandDescendY) * playGeo.size.height * 0.58
                                FeatherWandView(
                                    attachPoint: attachPoint,
                                    tipPoint: CGPoint(x: tipX, y: tipY),
                                    inReach: gameState.wandDescendY > 0.60
                                )
                                .zIndex(10)
                            }

                            if gameState.showCatchEffect {
                                CatchEffect()
                                    .position(catCenter)
                                    .transition(.opacity)
                                    .zIndex(20)
                            }

if gameState.currentMode == .cuddle {
                                Color.clear.contentShape(Rectangle())
                                    .gesture(DragGesture(minimumDistance: 0)
                                        .onChanged { v in gameState.startPetting(at: v.location) }
                                        .onEnded { _ in gameState.stopPetting() }
                                    )
                            }
                        }
                        .onChange(of: gameState.currentMode) {
                            if gameState.currentMode == .treats { gameState.setupTreats(in: playGeo.size) }
                            if gameState.currentMode == .toys   { gameState.startWand() }
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
                            Label("Tilt your phone to swing the wand!", systemImage: "rotate.3d")
                        }
                    }
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.52))
                    .padding(.bottom, 14)

                    // Mode tab bar
                    HStack(spacing: 8) {
                        ModeTabButton(icon: "🐱", label: "Cuddle", isActive: gameState.currentMode == .cuddle) { gameState.switchMode(to: .cuddle) }
                        ModeTabButton(icon: "🍖", label: "Treats", isActive: gameState.currentMode == .treats) { gameState.switchMode(to: .treats) }
                        ModeTabButton(icon: "🪶", label: "Wand",   isActive: gameState.currentMode == .toys)   { gameState.switchMode(to: .toys) }
                    }
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.14), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.22), radius: 16, x: 0, y: 6)
                    .padding(.horizontal, 40).padding(.bottom, 36)
                }

                if gameState.showFullScreenCelebration, let cat = gameState.selectedCat {
                    FullScreenCelebrationView(
                        imageSource: gameState.getImageForCat(cat),
                        catName: cat.name,
                        gameState: gameState
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                    .zIndex(200)
                }
            }
        }
    }
}
