// Happiness — startPetting, purrIntensity, stopPetting, generateHearts

import XCTest
@testable import CatCudding

@MainActor
final class GameStateHappinessTests: XCTestCase {

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

    func test_happiness_defaultsZero() {
        XCTAssertEqual(sut.happiness, 0, accuracy: 0.001)
    }

    func test_purrIntensity_defaultsZero() {
        XCTAssertEqual(sut.purrIntensity, 0, accuracy: 0.001)
    }

    func test_isBeingPetted_defaultsFalse() {
        XCTAssertFalse(sut.isBeingPetted)
    }

    func test_hearts_defaultEmpty() {
        XCTAssertTrue(sut.hearts.isEmpty)
    }

    func test_sparkles_defaultEmpty() {
        XCTAssertTrue(sut.sparkles.isEmpty)
    }

    // MARK: startPetting

    func test_startPetting_setsIsBeingPettedTrue() {
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        XCTAssertTrue(sut.isBeingPetted)
    }

    func test_startPetting_incrementsHappinessByFive() {
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(sut.happiness, 5, accuracy: 0.001)
    }

    func test_startPetting_incrementsPurrIntensity() {
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        XCTAssertGreaterThan(sut.purrIntensity, 0)
    }

    func test_startPetting_purrIntensityIncrementIs0_06() {
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(sut.purrIntensity, 0.06, accuracy: 0.001)
    }

    func test_startPetting_capsPurrIntensityAtOne() {
        sut.purrIntensity = 0.98
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(sut.purrIntensity, 1.0, accuracy: 0.001)
    }

    func test_startPetting_happinessDoesNotExceed100() {
        sut.happiness = 98
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(sut.happiness, 100, accuracy: 0.001)
    }

    func test_startPetting_secondImmediateCall_doesNotAddHappiness() {
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        let afterFirst = sut.happiness
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(sut.happiness, afterFirst, accuracy: 0.001)
    }

    func test_startPetting_setsPetDragLocation() {
        let pt = CGPoint(x: 150, y: 200)
        sut.startPetting(at: pt)
        let loc = try! XCTUnwrap(sut.petDragLocation)
        XCTAssertEqual(loc.x, pt.x, accuracy: 0.001)
        XCTAssertEqual(loc.y, pt.y, accuracy: 0.001)
    }

    // MARK: stopPetting

    func test_stopPetting_clearsIsBeingPetted() {
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        sut.stopPetting()
        XCTAssertFalse(sut.isBeingPetted)
    }

    func test_stopPetting_clearsPetDragLocation() {
        sut.startPetting(at: CGPoint(x: 100, y: 100))
        sut.stopPetting()
        XCTAssertNil(sut.petDragLocation)
    }

    // MARK: generateHearts

    func test_generateHearts_addsThreeHearts() {
        sut.generateHearts(at: CGPoint(x: 200, y: 200))
        XCTAssertEqual(sut.hearts.count, 3)
    }

    func test_generateHearts_heartsAreNearTheGivenLocation() {
        let location = CGPoint(x: 200, y: 300)
        sut.generateHearts(at: location)
        for heart in sut.hearts {
            XCTAssertEqual(heart.x, location.x, accuracy: 45)
            XCTAssertEqual(heart.y, location.y, accuracy: 25)
        }
    }

    func test_generateHearts_heartsHaveFullOpacity() {
        sut.generateHearts(at: .zero)
        for heart in sut.hearts {
            XCTAssertEqual(heart.opacity, 1.0, accuracy: 0.001)
        }
    }

    func test_generateHearts_calledTwice_addsToExistingHearts() {
        sut.generateHearts(at: .zero)
        sut.generateHearts(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(sut.hearts.count, 6)
    }
}
