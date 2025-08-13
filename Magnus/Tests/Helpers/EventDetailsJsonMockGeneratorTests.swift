import XCTest
@testable import MagnusDomain
@testable import MagnusFeatures

final class EventDetailsJsonMockGeneratorTests: XCTestCase {

    func test_mainInfo_matchesTopLevelFields() {
        // Given
        guard let model = EventDetailsJsonMockGenerator.generateObject() else {
            return XCTFail("Expected decoded model")
        }

        // When
        let main = model.mainInfo

        // Then
        XCTAssertEqual(main.title, model.title)
        XCTAssertEqual(main.date_from, model.date_from)
        XCTAssertEqual(main.date_to, model.date_to)
        XCTAssertEqual(main.image, model.image)
        XCTAssertEqual(main.name, model.name)
        XCTAssertEqual(main.description, model.description)
    }
}

