// Treats — setupTreats layout, dragTreat, dropTreat distance logic

import XCTest
@testable import CatCudding

@MainActor
final class GameStateTreatsTests: XCTestCase {

    var sut: GameState!
    let testSize = CGSize(width: 400, height: 600)

    override func setUp() {
        super.setUp()
        sut = GameState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: setupTreats

    func test_draggableTreats_defaultEmpty() {
        XCTAssertTrue(sut.draggableTreats.isEmpty)
    }

    func test_setupTreats_createsFourTreats() {
        sut.setupTreats(in: testSize)
        XCTAssertEqual(sut.draggableTreats.count, 4)
    }

    func test_setupTreats_orderIsFishMeatShrimpChicken() {
        sut.setupTreats(in: testSize)
        XCTAssertEqual(sut.draggableTreats[0].type, .fish)
        XCTAssertEqual(sut.draggableTreats[1].type, .meat)
        XCTAssertEqual(sut.draggableTreats[2].type, .shrimp)
        XCTAssertEqual(sut.draggableTreats[3].type, .chicken)
    }

    func test_setupTreats_yPositionIsHeight_minus80() {
        sut.setupTreats(in: testSize)
        let expectedY = testSize.height - 80
        for treat in sut.draggableTreats {
            XCTAssertEqual(treat.position.y, expectedY, accuracy: 0.001)
        }
    }

    func test_setupTreats_xPositionsAreEvenlySpaced() {
        sut.setupTreats(in: testSize)
        let spacing = testSize.width / 5  // width / (count + 1)
        for (i, treat) in sut.draggableTreats.enumerated() {
            XCTAssertEqual(treat.position.x, spacing * CGFloat(i + 1), accuracy: 0.001)
        }
    }

    func test_setupTreats_startPositionMatchesInitialPosition() {
        sut.setupTreats(in: testSize)
        for treat in sut.draggableTreats {
            XCTAssertEqual(treat.position.x, treat.startPosition.x, accuracy: 0.001)
            XCTAssertEqual(treat.position.y, treat.startPosition.y, accuracy: 0.001)
        }
    }

    func test_setupTreats_whenAlreadyPopulated_isNoOp() {
        sut.setupTreats(in: testSize)
        let firstId = sut.draggableTreats[0].id
        sut.setupTreats(in: CGSize(width: 800, height: 1000))
        XCTAssertEqual(sut.draggableTreats[0].id, firstId)
    }

    // MARK: dragTreat

    func test_dragTreat_updatesPosition() {
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[0]
        let newPos = CGPoint(x: 250, y: 250)
        sut.dragTreat(treat.id, to: newPos)
        XCTAssertEqual(sut.draggableTreats[0].position.x, newPos.x, accuracy: 0.001)
        XCTAssertEqual(sut.draggableTreats[0].position.y, newPos.y, accuracy: 0.001)
    }

    func test_dragTreat_setsIsDraggingTrue() {
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[0]
        sut.dragTreat(treat.id, to: CGPoint(x: 200, y: 200))
        XCTAssertTrue(sut.draggableTreats[0].isDragging)
    }

    func test_dragTreat_withUnknownId_isNoOp() {
        sut.setupTreats(in: testSize)
        let countBefore = sut.draggableTreats.count
        sut.dragTreat(UUID(), to: CGPoint(x: 200, y: 200))
        XCTAssertEqual(sut.draggableTreats.count, countBefore)
    }

    // MARK: dropTreat — within range (<120) eats the treat

    func test_dropTreat_withinRange_marksAsEaten() {
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[0]
        let catCenter = CGPoint(x: treat.startPosition.x + 50, y: treat.startPosition.y)
        sut.dragTreat(treat.id, to: catCenter)
        sut.dropTreat(treat.id, catCenter: catCenter)
        XCTAssertTrue(sut.draggableTreats[0].isEaten)
    }

    func test_dropTreat_withinRange_increasesHappiness() {
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[0]
        let catCenter = CGPoint(x: treat.startPosition.x, y: treat.startPosition.y)
        sut.dragTreat(treat.id, to: catCenter)
        sut.dropTreat(treat.id, catCenter: catCenter)
        XCTAssertGreaterThan(sut.happiness, 0)
    }

    func test_dropTreat_withinRange_happinessDoesNotExceed100() {
        sut.happiness = 95
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[1]  // meat, +30 — would exceed 100
        let catCenter = treat.startPosition
        sut.dragTreat(treat.id, to: catCenter)
        sut.dropTreat(treat.id, catCenter: catCenter)
        XCTAssertLessThanOrEqual(sut.happiness, 100)
    }

    // MARK: dropTreat — outside range (>=120) springs back

    func test_dropTreat_outsideRange_returnsTreatToStart() {
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[0]
        let startX = treat.startPosition.x
        let startY = treat.startPosition.y
        // drag 200pt away, cat center far from drop point
        let farPoint = CGPoint(x: startX + 200, y: startY)
        let catCenter = CGPoint(x: 10, y: 10)  // dist from farPoint >> 120
        sut.dragTreat(treat.id, to: farPoint)
        sut.dropTreat(treat.id, catCenter: catCenter)
        XCTAssertEqual(sut.draggableTreats[0].position.x, startX, accuracy: 0.001)
        XCTAssertEqual(sut.draggableTreats[0].position.y, startY, accuracy: 0.001)
    }

    func test_dropTreat_outsideRange_clearsDragging() {
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[0]
        sut.dragTreat(treat.id, to: CGPoint(x: 350, y: 50))
        sut.dropTreat(treat.id, catCenter: CGPoint(x: 10, y: 10))
        XCTAssertFalse(sut.draggableTreats[0].isDragging)
    }

    func test_dropTreat_outsideRange_doesNotMarkAsEaten() {
        sut.setupTreats(in: testSize)
        let treat = sut.draggableTreats[0]
        sut.dragTreat(treat.id, to: CGPoint(x: 350, y: 50))
        sut.dropTreat(treat.id, catCenter: CGPoint(x: 10, y: 10))
        XCTAssertFalse(sut.draggableTreats[0].isEaten)
    }
}
