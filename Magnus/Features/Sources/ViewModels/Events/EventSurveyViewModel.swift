import MagnusDomain
import Foundation   
import Combine

@MainActor
public class EventSurveyViewModel: ObservableObject {
    @Published public var eventId: String
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    @Published public var survey: SurveyForEvent?
    @Published public var currentQuestionDetails: SurveyQueryDetails?
    @Published public var currentQuestionNumber: Int = 0

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

    public func nextQuestion() async {
        currentQuestionNumber += 1
        await loadQuestionDetails(queryId: survey?.queries[currentQuestionNumber - 1].id ?? "")
    }

    // public func firstQuestion() async {
    //     await loadQuestionDetails(queryId: survey?.queries[0].id ?? "")
    // }
        
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
                errorMessage = "No cached event details found."
            }
        }
    }

    public func loadQuestionDetails(queryId: String) async {

        print("Loading question details for queryId: \(queryId)")
        print("Current question number: \(currentQuestionNumber)")

        await MainActor.run {
            self.isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data = try await surveyService.getSurveyQueryDetails(queryId: queryId)

            print("Loaded question details: \(data)")

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