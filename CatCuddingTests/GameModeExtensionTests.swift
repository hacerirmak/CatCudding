// GameMode & CustomCatUploadError model tests

import XCTest
@testable import CatCudding

final class GameModeExtensionTests: XCTestCase {

    // MARK: displayName

    func test_displayName_cuddle() {
        XCTAssertEqual(GameMode.cuddle.displayName, "Cuddle")
    }

    func test_displayName_treats() {
        XCTAssertEqual(GameMode.treats.displayName, "Treats")
    }

    func test_displayName_toys() {
        XCTAssertEqual(GameMode.toys.displayName, "Wand")
    }

    // MARK: modeEmoji

    func test_modeEmoji_cuddle() {
        XCTAssertEqual(GameMode.cuddle.modeEmoji, "🐾")
    }

    func test_modeEmoji_treats() {
        XCTAssertEqual(GameMode.treats.modeEmoji, "🍪")
    }

    func test_modeEmoji_toys() {
        XCTAssertEqual(GameMode.toys.modeEmoji, "🧶")
    }

    // MARK: subtitle

    func test_subtitles_allNonEmpty() {
        XCTAssertFalse(GameMode.cuddle.subtitle.isEmpty)
        XCTAssertFalse(GameMode.treats.subtitle.isEmpty)
        XCTAssertFalse(GameMode.toys.subtitle.isEmpty)
    }

    func test_subtitles_allDifferent() {
        let subs = [GameMode.cuddle.subtitle, GameMode.treats.subtitle, GameMode.toys.subtitle]
        XCTAssertEqual(Set(subs).count, 3)
    }

    // MARK: Identifiable

    func test_identifiable_idEqualsSelf() {
        XCTAssertEqual(GameMode.cuddle.id, .cuddle)
        XCTAssertEqual(GameMode.treats.id, .treats)
        XCTAssertEqual(GameMode.toys.id, .toys)
    }

    func test_identifiable_allIdsAreUnique() {
        let ids = [GameMode.cuddle.id, GameMode.treats.id, GameMode.toys.id]
        XCTAssertEqual(Set(ids).count, 3)
    }

    // MARK: Equatable (needed for switchMode guard)

    func test_sameMode_isEqual() {
        XCTAssertEqual(GameMode.cuddle, GameMode.cuddle)
        XCTAssertEqual(GameMode.treats, GameMode.treats)
        XCTAssertEqual(GameMode.toys, GameMode.toys)
    }

    func test_differentModes_areNotEqual() {
        XCTAssertNotEqual(GameMode.cuddle, GameMode.treats)
        XCTAssertNotEqual(GameMode.treats, GameMode.toys)
        XCTAssertNotEqual(GameMode.cuddle, GameMode.toys)
    }
}

final class CustomCatUploadErrorTests: XCTestCase {

    // MARK: Identifiable

    func test_identifiable_allCasesEqualThemselves() {
        XCTAssertEqual(CustomCatUploadError.loadFailed.id,        .loadFailed)
        XCTAssertEqual(CustomCatUploadError.bgRemovalFailed.id,   .bgRemovalFailed)
        XCTAssertEqual(CustomCatUploadError.unsupported.id,       .unsupported)
        XCTAssertEqual(CustomCatUploadError.permissionDenied.id,  .permissionDenied)
    }

    func test_identifiable_allIdsAreUnique() {
        let errors: [CustomCatUploadError] = [.loadFailed, .bgRemovalFailed, .unsupported, .permissionDenied]
        let ids = errors.map(\.id)
        XCTAssertEqual(Set(ids).count, errors.count)
    }

    // MARK: Equatable (needed for sheet item binding)

    func test_sameCase_isEqual() {
        XCTAssertEqual(CustomCatUploadError.bgRemovalFailed, .bgRemovalFailed)
        XCTAssertEqual(CustomCatUploadError.permissionDenied, .permissionDenied)
    }

    func test_differentCases_areNotEqual() {
        XCTAssertNotEqual(CustomCatUploadError.loadFailed, .bgRemovalFailed)
        XCTAssertNotEqual(CustomCatUploadError.unsupported, .permissionDenied)
    }
}
