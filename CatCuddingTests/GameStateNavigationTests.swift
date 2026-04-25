// Navigation & cat selection — currentScreen, selectCat, resetGame, cats array, getImageForCat

import XCTest
@testable import CatCudding

@MainActor
final class GameStateNavigationTests: XCTestCase {

    var sut: GameState!

    override func setUp() {
        super.setUp()
        sut = GameState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Initial navigation state

    func test_currentScreen_defaultsWelcome() {
        XCTAssertEqual(sut.currentScreen, .welcome)
    }

    func test_selectedCat_defaultsNil() {
        XCTAssertNil(sut.selectedCat)
    }

    func test_currentMode_defaultsCuddle() {
        XCTAssertEqual(sut.currentMode, .cuddle)
    }

    func test_selectedBackground_defaultsDefault() {
        XCTAssertEqual(sut.selectedBackground, .default)
    }

    // MARK: selectCat

    func test_selectCat_setsSelectedCat() {
        let cat = sut.cats[0]
        sut.selectCat(cat)
        XCTAssertEqual(sut.selectedCat, cat)
    }

    func test_selectCat_canSelectAnyBuiltIn() {
        for cat in sut.cats {
            sut.selectCat(cat)
            XCTAssertEqual(sut.selectedCat, cat)
        }
    }

    func test_selectCat_replacingPreviousSelection() {
        sut.selectCat(sut.cats[0])
        sut.selectCat(sut.cats[1])
        XCTAssertEqual(sut.selectedCat, sut.cats[1])
    }

    // MARK: Built-in cats array

    func test_cats_hasThreeEntries() {
        XCTAssertEqual(sut.cats.count, 3)
    }

    func test_cats_firstIsWhiskers() {
        XCTAssertEqual(sut.cats[0].name, "Whiskers")
    }

    func test_cats_secondIsCloudy() {
        XCTAssertEqual(sut.cats[1].name, "Cloudy Paws")
    }

    func test_cats_thirdIsShadow() {
        XCTAssertEqual(sut.cats[2].name, "Shadow Pounce")
    }

    func test_cats_allHaveNonEmptyBreed() {
        for cat in sut.cats {
            XCTAssertFalse(cat.breed.isEmpty, "\(cat.name) has empty breed")
        }
    }

    func test_cats_noneAreCustom() {
        for cat in sut.cats {
            XCTAssertFalse(cat.isCustom, "\(cat.name) should not be custom")
        }
    }

    // MARK: resetGame

    func test_resetGame_setsHappinessToZero() {
        sut.happiness = 75
        sut.resetGame()
        XCTAssertEqual(sut.happiness, 0, accuracy: 0.001)
    }

    func test_resetGame_clearsCelebration() {
        sut.showFullScreenCelebration = true
        sut.resetGame()
        XCTAssertFalse(sut.showFullScreenCelebration)
    }

    func test_resetGame_setsModeBackToCuddle() {
        sut.pendingModeSwitch = .treats
        sut.confirmModeSwitch(keepHappiness: true)
        sut.resetGame()
        XCTAssertEqual(sut.currentMode, .cuddle)
    }

    func test_resetGame_clearsIsBeingPetted() {
        sut.isBeingPetted = true
        sut.resetGame()
        XCTAssertFalse(sut.isBeingPetted)
    }

    func test_resetGame_clearsPurrIntensity() {
        sut.purrIntensity = 0.8
        sut.resetGame()
        XCTAssertEqual(sut.purrIntensity, 0, accuracy: 0.001)
    }

    func test_resetGame_clearsDraggableTreats() {
        sut.setupTreats(in: CGSize(width: 400, height: 600))
        sut.resetGame()
        XCTAssertTrue(sut.draggableTreats.isEmpty)
    }

    func test_resetGame_clearsHearts() {
        sut.generateHearts(at: .zero)
        sut.resetGame()
        XCTAssertTrue(sut.hearts.isEmpty)
    }

    func test_resetGame_clearsSparkles() {
        sut.sparkles = [FloatingElement(x: 0, y: 0)]
        sut.resetGame()
        XCTAssertTrue(sut.sparkles.isEmpty)
    }

    // MARK: getImageForCat

    func test_getImageForCat_customCat_returnsCustomCatImage() {
        let image = UIImage()
        sut.customCatImage = image
        let customCat = Cat(name: "Mochi", description: "D", breed: "Custom Cat", color: .purple, emoji: "💜", isCustom: true)
        let result = sut.getImageForCat(customCat)
        XCTAssertTrue(result is UIImage)
    }

    func test_getImageForCat_builtInCat_returnsNonNil() {
        let result = sut.getImageForCat(sut.cats[0])
        XCTAssertNotNil(result)
    }

    func test_getImageForCat_builtInCat_returnsStringNameWhenUnprocessed() {
        // processedCatImages[i] is nil until async bg removal completes
        let result = sut.getImageForCat(sut.cats[0])
        // Returns catImages[i] (String) as fallback
        XCTAssertTrue(result is String)
    }

    func test_getImageForCat_unknownCat_returnsNil() {
        let stranger = Cat(name: "Unknown", description: "D", breed: "B", color: .blue, emoji: "🐱")
        let result = sut.getImageForCat(stranger)
        XCTAssertNil(result)
    }
}
