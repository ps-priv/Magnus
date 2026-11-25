import Foundation
import XCTest

@testable import MagnusDomain
@testable import MagnusFeatures

final class AgendaAssessmentRequestTests: XCTestCase {
    func test_encoding_usesApiKeys() throws {
        let request = AgendaAssessmentRequest(
            agenda_content_id: "eyJpZCI6MSwidG9rZW4iOiIxNnxDZER2cVk1UnhqN0VBd0F3WDQ0RTExa1lnczhTdzJkcndLaGxXZUhiMzVkZTgxMDYifQ==",
            description: "Bardzo fajne",
            assessment: 3
        )

        let data = try JSONEncoder().encode(request)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])

        XCTAssertEqual(Set(json.keys), ["agenda_content_id", "description", "assessment"])
        XCTAssertEqual(json["agenda_content_id"] as? String, request.agenda_content_id)
        XCTAssertEqual(json["description"] as? String, "Bardzo fajne")
        XCTAssertEqual(json["assessment"] as? Int, 3)
    }
}

@MainActor
final class AgendaAssessmentViewModelTests: XCTestCase {
    private func makeSut(error: Error? = nil) -> (AgendaAssessmentViewModel, AgendaAssessmentServiceMock) {
        let mock = AgendaAssessmentServiceMock(error: error, delay: .zero)
        return (AgendaAssessmentViewModel(agendaContentId: "abc==", agendaAssessmentService: mock), mock)
    }

    func test_selectStar_setsAndTogglesOff() {
        let (sut, _) = makeSut()
        XCTAssertEqual(sut.assessment, 0)
        sut.selectStar(3)
        XCTAssertEqual(sut.assessment, 3)
        sut.selectStar(5)
        XCTAssertEqual(sut.assessment, 5)
        sut.selectStar(5)
        XCTAssertEqual(sut.assessment, 0)
    }

    func test_submit_success_sendsRequestAndMarksSubmitted() async {
        let (sut, mock) = makeSut()
        sut.selectStar(3)
        sut.description = "Bardzo fajne"

        await sut.submit()

        XCTAssertTrue(sut.isSubmitted)
        XCTAssertFalse(sut.isSubmitting)
        XCTAssertFalse(sut.hasError)
        XCTAssertEqual(mock.submittedRequests,
                       [AgendaAssessmentRequest(agenda_content_id: "abc==", description: "Bardzo fajne", assessment: 3)])
    }

    func test_submit_withoutDescription_sendsEmptyString() async {
        let (sut, mock) = makeSut()
        sut.selectStar(5)

        await sut.submit()

        XCTAssertEqual(mock.submittedRequests.first?.description, "")
        XCTAssertEqual(mock.submittedRequests.first?.assessment, 5)
    }

    func test_submit_failure_keepsInputAndShowsError() async {
        let (sut, _) = makeSut(error: URLError(.badServerResponse))
        sut.selectStar(4)
        sut.description = "Ok"

        await sut.submit()

        XCTAssertTrue(sut.hasError)
        XCTAssertFalse(sut.isSubmitted)
        XCTAssertFalse(sut.isSubmitting)
        XCTAssertEqual(sut.assessment, 4)
        XCTAssertEqual(sut.description, "Ok")
    }
}
