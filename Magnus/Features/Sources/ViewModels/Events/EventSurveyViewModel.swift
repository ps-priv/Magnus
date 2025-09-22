import MagnusDomain
import Foundation   
import Combine

public struct SurveyAnswerData {
    public let questionId: String
    public let questionType: QueryTypeEnum
    public let selectedAnswers: [String]
    public let openAnswer: String?
    
    public init(questionId: String, questionType: QueryTypeEnum, selectedAnswers: [String], openAnswer: String?) {
        self.questionId = questionId
        self.questionType = questionType
        self.selectedAnswers = selectedAnswers
        self.openAnswer = openAnswer
    }

    public func getSurveyAnswer() -> SurveyAnswer {
        if questionType == .open {
            return SurveyAnswer.createOpen(query_id: questionId, answer_text: openAnswer!, answer_id: selectedAnswers[0])
        } else {
            return SurveyAnswer.createChoice(query_id: questionId, answers_id: selectedAnswers)
        }
    }
}

@MainActor
public class EventSurveyViewModel: ObservableObject {
    @Published public var eventId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var survey: SurveyForEvent?
    @Published public var currentQuestionDetails: SurveyQueryDetails?
    @Published public var currentQuestionNumber: Int = 0
    @Published public var isSurveyCompleted: Bool = false
    
    @Published public var buttonTitle: String = FeaturesLocalizedStrings.surveyStartButton

    private let surveyService: SurveyService

    public init(eventId: String, 
        surveyService: SurveyService = DIContainer.shared.surveyService) {
        self.eventId = eventId
        self.surveyService = surveyService

        Task {
            await loadData()
        }
    }
    public func nextQuestion(with answerData: SurveyAnswerData? = nil) async {
        guard let survey = survey else { return }
        
        // Store the answer if provided
        if let answerData = answerData {
            let answer = answerData.getSurveyAnswer()

            do {
                try await surveyService.submitAnswers(answers: answer)
                //print("Collected answer: \(answer)")
            } catch {
                print("Error submitting answer: \(error)")
            }
        }
        
        currentQuestionNumber += 1
        
        // Check if we've completed all questions
        if currentQuestionNumber > survey.queries.count {
            await MainActor.run {
                isSurveyCompleted = true
            }
        } else {
            await loadQuestionDetails(queryId: survey.queries[currentQuestionNumber - 1].id)
            
            // Update button title
            await MainActor.run {
                if currentQuestionNumber == survey.queries.count {
                    buttonTitle = FeaturesLocalizedStrings.surveyCompleteButton
                } else {
                    buttonTitle = FeaturesLocalizedStrings.surveyNextButton
                }
            }
        }
    }

    public func loadData() async {
        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data = try await surveyService.getSurveyForEvent(eventId: eventId)

            await MainActor.run {
                survey = data
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                hasError = true
                errorMessage = "No cached event details found."
            }
        }
    }

    public func getSurveyStatus() -> SurveyStatusEnum {
        return survey?.survey_status ?? .before
    }

    public func loadQuestionDetails(queryId: String) async {

        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data = try await surveyService.getSurveyQueryDetails(queryId: queryId)

            //print("Loaded question details: \(data)")

            await MainActor.run {
                currentQuestionDetails = data
                isLoading = false
            }
        } catch {
            await MainActor.run {
                print("Error loading question details: \(error)")
                hasError = true
                isLoading = false
                errorMessage = "No cached event details found."
            }
        }
    }

    public func submitAnswers(answers: SurveyAnswer) async {

        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            try await surveyService.submitAnswers(answers: answers)

            await MainActor.run {
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "No cached survey details found."
            }
        }
    }
}