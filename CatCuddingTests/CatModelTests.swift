// Cat struct — Equatable, isCustom, properties

import XCTest
@testable import CatCudding

final class CatModelTests: XCTestCase {

    // MARK: Default isCustom

    func test_isCustom_defaultsFalse() {
        let cat = Cat(name: "Luna", description: "Desc", breed: "Tabby", color: .orange, emoji: "🧡")
        XCTAssertFalse(cat.isCustom)
    }

    func test_isCustom_canBeSetTrue() {
        let cat = Cat(name: "Luna", description: "Desc", breed: "Tabby", color: .orange, emoji: "🧡", isCustom: true)
        XCTAssertTrue(cat.isCustom)
    }

    // MARK: Properties stored correctly

    func test_name_storedCorrectly() {
        let cat = Cat(name: "Mochi", description: "D", breed: "B", color: .blue, emoji: "🐱")
        XCTAssertEqual(cat.name, "Mochi")
    }

    func test_breed_storedCorrectly() {
        let cat = Cat(name: "N", description: "D", breed: "Ragdoll", color: .blue, emoji: "🐱")
        XCTAssertEqual(cat.breed, "Ragdoll")
    }

    func test_emoji_storedCorrectly() {
        let cat = Cat(name: "N", description: "D", breed: "B", color: .blue, emoji: "💜")
        XCTAssertEqual(cat.emoji, "💜")
    }

    func test_description_storedCorrectly() {
        let cat = Cat(name: "N", description: "Fluffy friend", breed: "B", color: .blue, emoji: "🐱")
        XCTAssertEqual(cat.description, "Fluffy friend")
    }

    // MARK: Identifiable — unique ids

    func test_twoCats_haveDifferentIds() {
        let a = Cat(name: "Luna", description: "D", breed: "B", color: .orange, emoji: "🧡")
        let b = Cat(name: "Luna", description: "D", breed: "B", color: .orange, emoji: "🧡")
        XCTAssertNotEqual(a.id, b.id)
    }

    // MARK: Equatable — by id only

    func test_sameCatInstance_equalsItself() {
        let cat = Cat(name: "Luna", description: "D", breed: "B", color: .orange, emoji: "🧡")
        XCTAssertEqual(cat, cat)
    }

    func test_twoCatsWithSameName_areNotEqual() {
        let a = Cat(name: "Luna", description: "D", breed: "B", color: .orange, emoji: "🧡")
        let b = Cat(name: "Luna", description: "D", breed: "B", color: .orange, emoji: "🧡")
        XCTAssertNotEqual(a, b)
    }

    // MARK: ScreenType

    func test_screenType_allThreeCasesExist() {
        let screens: [ScreenType] = [.welcome, .selection, .game]
        XCTAssertEqual(screens.count, 3)
    }
}
