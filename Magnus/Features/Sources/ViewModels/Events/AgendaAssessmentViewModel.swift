import Foundation
import MagnusDomain

@MainActor
public class AgendaAssessmentViewModel: ObservableObject {

    public static let maxAssessment = 5

    private let agendaAssessmentService: AgendaAssessmentService

    public let agendaContentId: String
    @Published public var assessment: Int = 0
    @Published public var description: String = ""
    @Published public var isSubmitting: Bool = false
    @Published public var hasError: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var isSubmitted: Bool = false

    public init(agendaContentId: String,
                agendaAssessmentService: AgendaAssessmentService = DIContainer.shared.agendaAssessmentService) {
        self.agendaContentId = agendaContentId
        self.agendaAssessmentService = agendaAssessmentService
    }

    /// Ustawia ocenę na `star` (1...5). Ponowne dotknięcie najwyższej zaznaczonej gwiazdki zeruje ocenę.
    public func selectStar(_ star: Int) {
        let star = min(max(star, 0), Self.maxAssessment)
        assessment = (star == assessment) ? 0 : star
    }

    public func submit() async {
        guard !isSubmitting else { return }
        isSubmitting = true
        hasError = false
        errorMessage = ""

        let request = AgendaAssessmentRequest(
            agenda_content_id: agendaContentId,
            description: description,
            assessment: assessment
        )

        do {
            try await agendaAssessmentService.submitAssessment(request)
            isSubmitted = true
        } catch {
            errorMessage = error.localizedDescription
            hasError = true
        }
        isSubmitting = false
    }
}
