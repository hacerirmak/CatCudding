// S2 — Custom cat upload error states

import XCTest
@testable import CatCudding

@MainActor
final class GameStateCustomCatTests: XCTestCase {

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

    func test_customCatError_defaultsNil() {
        XCTAssertNil(sut.customCatError)
    }

    func test_pendingCustomCatImage_defaultsNil() {
        XCTAssertNil(sut.pendingCustomCatImage)
    }

    func test_pendingCustomCatName_defaultsEmpty() {
        XCTAssertEqual(sut.pendingCustomCatName, "")
    }

    // MARK: addCustomCat — pending state

    func test_addCustomCat_storesPendingImage() {
        let image = UIImage()
        sut.addCustomCat(image: image, name: "Mochi")
        XCTAssertNotNil(sut.pendingCustomCatImage)
    }

    func test_addCustomCat_storesPendingName() {
        sut.addCustomCat(image: UIImage(), name: "Mochi")
        XCTAssertEqual(sut.pendingCustomCatName, "Mochi")
    }

    func test_addCustomCat_emptyName_defaultsToMyCat() {
        sut.addCustomCat(image: UIImage(), name: "")
        XCTAssertEqual(sut.pendingCustomCatName, "My Cat")
    }

    func test_addCustomCat_whitespaceOnlyName_isPreservedAsPending() {
        sut.addCustomCat(image: UIImage(), name: "  ")
        XCTAssertEqual(sut.pendingCustomCatName, "  ")
    }

    // MARK: useCustomCatPhotoAnyway

    func test_usePhotoAnyway_withPendingImage_createsCustomCat() {
        sut.pendingCustomCatImage = UIImage()
        sut.pendingCustomCatName = "Mochi"
        sut.customCatError = .bgRemovalFailed

        sut.useCustomCatPhotoAnyway()

        XCTAssertNotNil(sut.customCat)
    }

    func test_usePhotoAnyway_setsCorrectCatName() {
        sut.pendingCustomCatImage = UIImage()
        sut.pendingCustomCatName = "Mochi"

        sut.useCustomCatPhotoAnyway()

        XCTAssertEqual(sut.customCat?.name, "Mochi")
    }

    func test_usePhotoAnyway_setsIsCustomTrue() {
        sut.pendingCustomCatImage = UIImage()
        sut.pendingCustomCatName = "Mochi"

        sut.useCustomCatPhotoAnyway()

        XCTAssertTrue(sut.customCat?.isCustom == true)
    }

    func test_usePhotoAnyway_clearsCustomCatError() {
        sut.pendingCustomCatImage = UIImage()
        sut.customCatError = .bgRemovalFailed

        sut.useCustomCatPhotoAnyway()

        XCTAssertNil(sut.customCatError)
    }

    func test_usePhotoAnyway_clearsPendingImage() {
        sut.pendingCustomCatImage = UIImage()

        sut.useCustomCatPhotoAnyway()

        XCTAssertNil(sut.pendingCustomCatImage)
    }

    func test_usePhotoAnyway_setsCustomCatImage() {
        let image = UIImage()
        sut.pendingCustomCatImage = image

        sut.useCustomCatPhotoAnyway()

        XCTAssertNotNil(sut.customCatImage)
    }

    func test_usePhotoAnyway_withNoPendingImage_doesNotCreateCat() {
        sut.pendingCustomCatImage = nil

        sut.useCustomCatPhotoAnyway()

        XCTAssertNil(sut.customCat)
    }

    func test_usePhotoAnyway_withNoPendingImage_doesNotClearError() {
        sut.customCatError = .bgRemovalFailed
        sut.pendingCustomCatImage = nil

        sut.useCustomCatPhotoAnyway()

        XCTAssertEqual(sut.customCatError, .bgRemovalFailed)
    }

    // MARK: Custom cat properties (via finalizeCustomCat path)

    func test_usePhotoAnyway_catHasCorrectBreed() {
        sut.pendingCustomCatImage = UIImage()
        sut.pendingCustomCatName = "Mochi"

        sut.useCustomCatPhotoAnyway()

        XCTAssertEqual(sut.customCat?.breed, "Custom Cat")
    }

    func test_usePhotoAnyway_catHasCorrectEmoji() {
        sut.pendingCustomCatImage = UIImage()
        sut.pendingCustomCatName = "Test"

        sut.useCustomCatPhotoAnyway()

        XCTAssertEqual(sut.customCat?.emoji, "💜")
    }
}
