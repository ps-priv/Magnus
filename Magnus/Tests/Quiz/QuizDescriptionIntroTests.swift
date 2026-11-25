import Foundation
import XCTest

@testable import MagnusApplication
@testable import MagnusDomain
@testable import MagnusFeatures

final class QuizForEventDecodingTests: XCTestCase {
    private func decode(_ json: String) throws -> QuizForEvent {
        try JSONDecoder().decode(QuizForEvent.self, from: Data(json.utf8))
    }

    func test_decode_withDescription() throws {
        let quiz = try decode(#"{"description":"Proszę wypełniać <b>powoli</b> i dokładnie","sequential":0,"queries":[{"id":"a","query_no":1,"query_type":1,"query_text":"Pierwsze pytanie checkbox"}]}"#)
        XCTAssertEqual(quiz.description, "Proszę wypełniać <b>powoli</b> i dokładnie")
        XCTAssertEqual(quiz.queries.count, 1)
    }

    func test_decode_withoutDescription() throws {
        XCTAssertNil(try decode(#"{"sequential":0,"queries":[]}"#).description)
    }

    func test_decode_nullDescription() throws {
        XCTAssertNil(try decode(#"{"description":null,"sequential":1,"queries":[]}"#).description)
    }
}

final class HtmlHelperTests: XCTestCase {
    func test_hasVisibleText() {
        for empty in [nil, "", "   ", "<p> </p>", "<p>&nbsp;</p>", "<br/>\n"] as [String?] {
            XCTAssertFalse(HtmlHelper.hasVisibleText(empty), "\(String(describing: empty))")
        }
        XCTAssertTrue(HtmlHelper.hasVisibleText("<b>Tekst</b>"))
    }

    @MainActor
    func test_attributedString_stripsTags() throws {
        let result = try XCTUnwrap(HtmlHelper.attributedString(
            fromHTML: "Proszę <b>powoli</b>", fontFamily: "Helvetica", fontSize: 16, colorHex: "001423"))
        XCTAssertEqual(String(result.characters), "Proszę powoli")
    }
}

private final class QuizServiceStub: QuizService {
    let quiz: QuizForEvent
    init(quiz: QuizForEvent) { self.quiz = quiz }
    func getQuizForAgenda(agendaId: String) async throws -> QuizForEvent { quiz }
    func getQuizQueryDetails(queryId: String) async throws -> QuizQueryAnswerResponse { throw URLError(.badURL) }
    func submitAnswers(answers: QuizUserAnswerRequest) async throws {}
}

@MainActor
final class AgendaQuizViewModelIntroTests: XCTestCase {
    private func makeLoadedSut(description: String?) async -> AgendaQuizViewModel {
        let sut = AgendaQuizViewModel(
            agendaId: "1",
            quizService: QuizServiceStub(quiz: QuizForEvent(sequential: .regular, queries: [], description: description)))
        await sut.loadData()
        return sut
    }

    func test_withDescription_showsIntroAndStartQuizButton() async {
        let sut = await makeLoadedSut(description: "Proszę wypełniać <b>powoli</b>")
        XCTAssertEqual(sut.introDescription, "Proszę wypełniać <b>powoli</b>")
        XCTAssertEqual(sut.buttonTitle, FeaturesLocalizedStrings.quizStartWithDescriptionButton)
    }

    func test_withoutDescription_keepsDefaultStart() async {
        let sut = await makeLoadedSut(description: "<p> </p>")
        XCTAssertNil(sut.introDescription)
        XCTAssertEqual(sut.buttonTitle, FeaturesLocalizedStrings.quizStartButton)
    }
}
