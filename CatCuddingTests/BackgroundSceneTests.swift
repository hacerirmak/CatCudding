// BackgroundScene — all 6 cases, rawValue/id/label/assetName/icon

import XCTest
@testable import CatCudding

final class BackgroundSceneTests: XCTestCase {

    // MARK: CaseIterable

    func test_allCases_hasSixScenes() {
        XCTAssertEqual(BackgroundScene.allCases.count, 6)
    }

    // MARK: id == rawValue == label

    func test_id_equalsRawValue() {
        for scene in BackgroundScene.allCases {
            XCTAssertEqual(scene.id, scene.rawValue, "id/rawValue mismatch for \(scene)")
        }
    }

    func test_label_equalsRawValue() {
        for scene in BackgroundScene.allCases {
            XCTAssertEqual(scene.label, scene.rawValue, "label/rawValue mismatch for \(scene)")
        }
    }

    // MARK: rawValues

    func test_rawValue_default() {
        XCTAssertEqual(BackgroundScene.default.rawValue, "Default")
    }

    func test_rawValue_meadow() {
        XCTAssertEqual(BackgroundScene.meadow.rawValue, "Meadow")
    }

    func test_rawValue_room() {
        XCTAssertEqual(BackgroundScene.room.rawValue, "Room")
    }

    func test_rawValue_space() {
        XCTAssertEqual(BackgroundScene.space.rawValue, "Space")
    }

    func test_rawValue_ocean() {
        XCTAssertEqual(BackgroundScene.ocean.rawValue, "Ocean")
    }

    func test_rawValue_candy() {
        XCTAssertEqual(BackgroundScene.candy.rawValue, "Candy")
    }

    // MARK: assetName has "bg_" prefix

    func test_allAssetNames_haveBgPrefix() {
        for scene in BackgroundScene.allCases {
            XCTAssertTrue(scene.assetName.hasPrefix("bg_"), "\(scene) assetName missing bg_ prefix")
        }
    }

    func test_assetName_default() {
        XCTAssertEqual(BackgroundScene.default.assetName, "bg_default")
    }

    func test_assetName_meadow() {
        XCTAssertEqual(BackgroundScene.meadow.assetName, "bg_meadow")
    }

    func test_assetName_room() {
        XCTAssertEqual(BackgroundScene.room.assetName, "bg_room")
    }

    func test_assetName_space() {
        XCTAssertEqual(BackgroundScene.space.assetName, "bg_space")
    }

    func test_assetName_ocean() {
        XCTAssertEqual(BackgroundScene.ocean.assetName, "bg_ocean")
    }

    func test_assetName_candy() {
        XCTAssertEqual(BackgroundScene.candy.assetName, "bg_candy")
    }

    // MARK: icon — non-empty SF Symbol name

    func test_allIcons_areNonEmpty() {
        for scene in BackgroundScene.allCases {
            XCTAssertFalse(scene.icon.isEmpty, "\(scene) icon is empty")
        }
    }

    func test_allIcons_areDistinct() {
        let icons = BackgroundScene.allCases.map(\.icon)
        XCTAssertEqual(Set(icons).count, 6)
    }

    // MARK: allIds are distinct

    func test_allIds_areDistinct() {
        let ids = BackgroundScene.allCases.map(\.id)
        XCTAssertEqual(Set(ids).count, 6)
    }
}
