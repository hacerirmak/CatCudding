// Wand — stopWand resets all toy state

import XCTest
@testable import CatCudding

@MainActor
final class GameStateWandTests: XCTestCase {

    var sut: GameState!

    override func setUp() {
        super.setUp()
        sut = GameState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Initial state

    func test_wandTiltX_defaultsZero() {
        XCTAssertEqual(sut.wandTiltX, 0, accuracy: 0.001)
    }

    func test_wandDescendY_defaultsZero() {
        XCTAssertEqual(sut.wandDescendY, 0, accuracy: 0.001)
    }

    func test_catIsExcited_defaultsFalse() {
        XCTAssertFalse(sut.catIsExcited)
    }

    func test_catZoomedIn_defaultsFalse() {
        XCTAssertFalse(sut.catZoomedIn)
    }

    func test_showCatchEffect_defaultsFalse() {
        XCTAssertFalse(sut.showCatchEffect)
    }

    // MARK: stopWand clears all wand state

    func test_stopWand_resetsWandTiltX() {
        sut.wandTiltX = 0.75
        sut.stopWand()
        XCTAssertEqual(sut.wandTiltX, 0, accuracy: 0.001)
    }

    func test_stopWand_resetsWandDescendY() {
        sut.wandDescendY = 0.8
        sut.stopWand()
        XCTAssertEqual(sut.wandDescendY, 0, accuracy: 0.001)
    }

    func test_stopWand_clearsCatIsExcited() {
        sut.catIsExcited = true
        sut.stopWand()
        XCTAssertFalse(sut.catIsExcited)
    }

    func test_stopWand_clearsCatZoomedIn() {
        sut.catZoomedIn = true
        sut.stopWand()
        XCTAssertFalse(sut.catZoomedIn)
    }

    func test_stopWand_clearsShowCatchEffect() {
        sut.showCatchEffect = true
        sut.stopWand()
        XCTAssertFalse(sut.showCatchEffect)
    }

    func test_stopWand_calledMultipleTimes_isIdempotent() {
        sut.wandTiltX = 0.5
        sut.stopWand()
        sut.stopWand()
        XCTAssertEqual(sut.wandTiltX, 0, accuracy: 0.001)
    }
}
