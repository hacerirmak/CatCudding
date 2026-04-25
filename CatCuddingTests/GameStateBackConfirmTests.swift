// S1 — Back confirm overlay state machine

import XCTest
@testable import CatCudding

@MainActor
final class GameStateBackConfirmTests: XCTestCase {

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

    func test_showBackConfirm_defaultsFalse() {
        XCTAssertFalse(sut.showBackConfirm)
    }

    // MARK: confirmLeave

    func test_confirmLeave_setsShowBackConfirmFalse() {
        sut.showBackConfirm = true
        sut.confirmLeave()
        XCTAssertFalse(sut.showBackConfirm)
    }

    func test_confirmLeave_navigatesToSelection() {
        sut.currentScreen = .game
        sut.confirmLeave()
        XCTAssertEqual(sut.currentScreen, .selection)
    }

    func test_confirmLeave_resetsHappinessToZero() {
        sut.happiness = 72
        sut.confirmLeave()
        XCTAssertEqual(sut.happiness, 0)
    }

    func test_confirmLeave_resetsModeToDefaultCuddle() {
        sut.pendingModeSwitch = .treats
        sut.confirmModeSwitch(keepHappiness: true)
        sut.confirmLeave()
        XCTAssertEqual(sut.currentMode, .cuddle)
    }

    func test_confirmLeave_clearsShowFullScreenCelebration() {
        sut.showFullScreenCelebration = true
        sut.confirmLeave()
        XCTAssertFalse(sut.showFullScreenCelebration)
    }

    func test_confirmLeave_fromWelcomeScreen_stillGoesToSelection() {
        sut.currentScreen = .welcome
        sut.confirmLeave()
        XCTAssertEqual(sut.currentScreen, .selection)
    }
}
