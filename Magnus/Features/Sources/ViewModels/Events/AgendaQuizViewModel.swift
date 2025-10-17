import MagnusDomain
import Foundation   
import Combine

@MainActor
public class AgendaQuizViewModel: ObservableObject {

    private let quizService: QuizService

    @Published public var agendaId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    // @Published public var survey: SurveyForEvent?
    // @Published public var currentQuestionDetails: SurveyQueryDetails?
    // @Published public var currentQuestionNumber: Int = 0
    // @Published public var isSurveyCompleted: Bool = false
    
    // @Published public var buttonTitle: String = FeaturesLocalizedStrings.surveyStartButton

    public init(agendaId: String, 
        quizService: QuizService = DIContainer.shared.quizService) {
        self.agendaId = agendaId
        self.quizService = quizService

        // Task {
        //     await loadData()
        // }
    }
}