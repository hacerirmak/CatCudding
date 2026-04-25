// FloatingElement model — Identifiable, default opacity, stored coords

import XCTest
@testable import CatCudding

final class FloatingElementTests: XCTestCase {

    // MARK: Default values

    func test_opacity_defaultsToOne() {
        let el = FloatingElement(x: 0, y: 0)
        XCTAssertEqual(el.opacity, 1.0, accuracy: 0.001)
    }

    func test_opacity_canBeSetExplicitly() {
        var el = FloatingElement(x: 0, y: 0)
        el.opacity = 0.5
        XCTAssertEqual(el.opacity, 0.5, accuracy: 0.001)
    }

    // MARK: Stored coordinates

    func test_x_storedCorrectly() {
        let el = FloatingElement(x: 123.5, y: 0)
        XCTAssertEqual(el.x, 123.5, accuracy: 0.001)
    }

    func test_y_storedCorrectly() {
        let el = FloatingElement(x: 0, y: -88.0)
        XCTAssertEqual(el.y, -88.0, accuracy: 0.001)
    }

    // MARK: Identifiable — unique ids per instance

    func test_twoElements_haveDifferentIds() {
        let a = FloatingElement(x: 10, y: 10)
        let b = FloatingElement(x: 10, y: 10)
        XCTAssertNotEqual(a.id, b.id)
    }
}
