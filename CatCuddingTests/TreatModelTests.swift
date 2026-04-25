// TreatType & DraggableTreat model tests

import XCTest
@testable import CatCudding

final class TreatTypeTests: XCTestCase {

    // MARK: CaseIterable

    func test_allCases_hasFourItems() {
        XCTAssertEqual(TreatType.allCases.count, 4)
    }

    // MARK: emoji

    func test_fish_emoji() {
        XCTAssertEqual(TreatType.fish.emoji, "🐟")
    }

    func test_meat_emoji() {
        XCTAssertEqual(TreatType.meat.emoji, "🍖")
    }

    func test_shrimp_emoji() {
        XCTAssertEqual(TreatType.shrimp.emoji, "🦐")
    }

    func test_chicken_emoji() {
        XCTAssertEqual(TreatType.chicken.emoji, "🍗")
    }

    func test_allEmojis_areDistinct() {
        let emojis = TreatType.allCases.map(\.emoji)
        XCTAssertEqual(Set(emojis).count, 4)
    }

    // MARK: happinessValue

    func test_fish_happinessValue() {
        XCTAssertEqual(TreatType.fish.happinessValue, 20, accuracy: 0.001)
    }

    func test_meat_happinessValue() {
        XCTAssertEqual(TreatType.meat.happinessValue, 30, accuracy: 0.001)
    }

    func test_shrimp_happinessValue() {
        XCTAssertEqual(TreatType.shrimp.happinessValue, 20, accuracy: 0.001)
    }

    func test_chicken_happinessValue() {
        XCTAssertEqual(TreatType.chicken.happinessValue, 30, accuracy: 0.001)
    }

    func test_totalHappiness_sumIs100() {
        let total = TreatType.allCases.reduce(0) { $0 + $1.happinessValue }
        XCTAssertEqual(total, 100, accuracy: 0.001)
    }

    // MARK: glowColor — one per case, all non-nil

    func test_allCases_glowColorIsNonNil() {
        for type in TreatType.allCases {
            // LinearGradient / Color are value types; just verifying they're reachable
            _ = type.glowColor
        }
    }
}

final class DraggableTreatTests: XCTestCase {

    private func makeTreat(at point: CGPoint = .zero) -> DraggableTreat {
        DraggableTreat(type: .fish, position: point, startPosition: point)
    }

    // MARK: Default values

    func test_isEaten_defaultsFalse() {
        XCTAssertFalse(makeTreat().isEaten)
    }

    func test_opacity_defaultsToOne() {
        XCTAssertEqual(makeTreat().opacity, 1.0, accuracy: 0.001)
    }

    func test_scale_defaultsToOne() {
        XCTAssertEqual(makeTreat().scale, 1.0, accuracy: 0.001)
    }

    func test_isDragging_defaultsFalse() {
        XCTAssertFalse(makeTreat().isDragging)
    }

    // MARK: Stored values

    func test_type_storedCorrectly() {
        let t = DraggableTreat(type: .chicken, position: .zero, startPosition: .zero)
        XCTAssertEqual(t.type, .chicken)
    }

    func test_startPosition_storedCorrectly() {
        let pt = CGPoint(x: 100, y: 200)
        let t = DraggableTreat(type: .fish, position: pt, startPosition: pt)
        XCTAssertEqual(t.startPosition.x, 100, accuracy: 0.001)
        XCTAssertEqual(t.startPosition.y, 200, accuracy: 0.001)
    }

    func test_startPosition_doesNotChangeWithPositionMutation() {
        let start = CGPoint(x: 50, y: 50)
        var t = DraggableTreat(type: .fish, position: start, startPosition: start)
        t.position = CGPoint(x: 300, y: 300)
        XCTAssertEqual(t.startPosition.x, 50, accuracy: 0.001)
        XCTAssertEqual(t.startPosition.y, 50, accuracy: 0.001)
    }

    // MARK: Identifiable — unique ids

    func test_twoTreats_haveDifferentIds() {
        let a = makeTreat()
        let b = makeTreat()
        XCTAssertNotEqual(a.id, b.id)
    }
}
