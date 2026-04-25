// S4 — Mode switch confirmation sheet state machine

import XCTest
@testable import CatCudding

@MainActor
final class GameStateModeSwitchTests: XCTestCase {

    var sut: GameState!

    override func setUp() {
        super.setUp()
        sut = GameState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: pendingModeSwitch initial state

    func test_pendingModeSwitch_defaultsNil() {
        XCTAssertNil(sut.pendingModeSwitch)
    }

    // MARK: switchMode — deferred, not immediate

    func test_switchMode_toNewMode_setsPending() {
        sut.switchMode(to: .treats)
        XCTAssertEqual(sut.pendingModeSwitch, .treats)
    }

    func test_switchMode_toNewMode_doesNotImmediatelySwitch() {
        sut.switchMode(to: .treats)
        XCTAssertEqual(sut.currentMode, .cuddle)
    }

    func test_switchMode_toCurrentMode_isNoOp() {
        sut.switchMode(to: .cuddle)
        XCTAssertNil(sut.pendingModeSwitch)
        XCTAssertEqual(sut.currentMode, .cuddle)
    }

    func test_switchMode_toToys_setsPendingToys() {
        sut.switchMode(to: .toys)
        XCTAssertEqual(sut.pendingModeSwitch, .toys)
    }

    func test_switchMode_secondCall_overwritesPending() {
        sut.switchMode(to: .treats)
        sut.switchMode(to: .toys)
        XCTAssertEqual(sut.pendingModeSwitch, .toys)
    }

    // MARK: confirmModeSwitch — keepHappiness: true

    func test_confirmModeSwitch_keepHappiness_switchesMode() {
        sut.switchMode(to: .treats)
        sut.confirmModeSwitch(keepHappiness: true)
        XCTAssertEqual(sut.currentMode, .treats)
    }

    func test_confirmModeSwitch_keepHappiness_preservesHappiness() {
        sut.happiness = 55
        sut.switchMode(to: .treats)
        sut.confirmModeSwitch(keepHappiness: true)
        XCTAssertEqual(sut.happiness, 55)
    }

    func test_confirmModeSwitch_keepHappiness_clearsPending() {
        sut.switchMode(to: .treats)
        sut.confirmModeSwitch(keepHappiness: true)
        XCTAssertNil(sut.pendingModeSwitch)
    }

    func test_confirmModeSwitch_keepHappiness_hidesCelebration() {
        sut.showFullScreenCelebration = true
        sut.switchMode(to: .treats)
        sut.confirmModeSwitch(keepHappiness: true)
        XCTAssertFalse(sut.showFullScreenCelebration)
    }

    // MARK: confirmModeSwitch — keepHappiness: false

    func test_confirmModeSwitch_resetHappiness_switchesMode() {
        sut.switchMode(to: .toys)
        sut.confirmModeSwitch(keepHappiness: false)
        XCTAssertEqual(sut.currentMode, .toys)
    }

    func test_confirmModeSwitch_resetHappiness_zeroesHappiness() {
        sut.happiness = 80
        sut.switchMode(to: .toys)
        sut.confirmModeSwitch(keepHappiness: false)
        XCTAssertEqual(sut.happiness, 0)
    }

    func test_confirmModeSwitch_resetHappiness_clearsPending() {
        sut.switchMode(to: .toys)
        sut.confirmModeSwitch(keepHappiness: false)
        XCTAssertNil(sut.pendingModeSwitch)
    }

    // MARK: confirmModeSwitch — no pending (guard)

    func test_confirmModeSwitch_withNoPending_doesNotChangeMode() {
        sut.currentMode = .cuddle
        sut.confirmModeSwitch(keepHappiness: true)
        XCTAssertEqual(sut.currentMode, .cuddle)
    }

    func test_confirmModeSwitch_withNoPending_doesNotChangeHappiness() {
        sut.happiness = 40
        sut.confirmModeSwitch(keepHappiness: false)
        XCTAssertEqual(sut.happiness, 40)
    }

    // MARK: cancelModeSwitch

    func test_cancelModeSwitch_clearsPending() {
        sut.switchMode(to: .toys)
        sut.cancelModeSwitch()
        XCTAssertNil(sut.pendingModeSwitch)
    }

    func test_cancelModeSwitch_doesNotChangeMode() {
        sut.switchMode(to: .treats)
        sut.cancelModeSwitch()
        XCTAssertEqual(sut.currentMode, .cuddle)
    }

    func test_cancelModeSwitch_withNoPending_remainsNil() {
        sut.cancelModeSwitch()
        XCTAssertNil(sut.pendingModeSwitch)
    }

    // MARK: All three modes round-trip

    func test_allModes_canBeSwitchedAndConfirmed() {
        let modes: [GameMode] = [.treats, .toys, .cuddle]
        for target in modes {
            sut.switchMode(to: target)
            if sut.pendingModeSwitch != nil {
                sut.confirmModeSwitch(keepHappiness: true)
            }
            XCTAssertEqual(sut.currentMode, target, "Expected \(target.displayName)")
        }
    }
}
