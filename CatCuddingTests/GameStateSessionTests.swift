// Celebration stats — session timer & streak

import XCTest
@testable import CatCudding

@MainActor
final class GameStateSessionTests: XCTestCase {

    var sut: GameState!

    override func setUp() {
        super.setUp()
        sut = GameState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: sessionDurationFormatted

    func test_sessionDurationFormatted_afterStartSession_returnsZeroZero() {
        sut.startSession()
        XCTAssertEqual(sut.sessionDurationFormatted, "0:00")
    }

    func test_sessionDurationFormatted_hasColonSeparator() {
        sut.startSession()
        XCTAssertTrue(sut.sessionDurationFormatted.contains(":"))
    }

    func test_sessionDurationFormatted_secondsAreTwoDigits() {
        sut.startSession()
        let parts = sut.sessionDurationFormatted.split(separator: ":")
        XCTAssertEqual(parts.count, 2)
        XCTAssertEqual(parts[1].count, 2)
    }

    func test_sessionDurationFormatted_minutesHaveNoLeadingZero() {
        sut.startSession()
        let parts = sut.sessionDurationFormatted.split(separator: ":")
        // Minutes part should be "0" not "00"
        XCTAssertEqual(parts[0], "0")
    }

    // MARK: streak

    func test_streak_defaultValue_isNonNegative() {
        XCTAssertGreaterThanOrEqual(sut.streak, 0)
    }

    func test_streak_defaultsTo7() {
        XCTAssertEqual(sut.streak, 7)
    }
}
