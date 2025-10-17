import Foundation
import Combine
import MagnusDomain

public class ApiQuizService: QuizService {
    private let surveyNetworkService: QuizNetworkServiceProtocol
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()

    public init(quizNetworkService: QuizNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.surveyNetworkService = surveyNetworkService
        self.authStorageService = authStorageService
    }

    public func getQuizForAgenda(eventId: String) async throws -> QuizForEvent {
        let token = try authStorageService.getAccessToken() ?? ""
        let survey = try await withCheckedThrowingContinuation { continuation in
            surveyNetworkService.getSurveyForEvent(token: token, eventId: eventId)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
                .store(in: &cancellables)
        }
        return survey
    }

    public func getQuizQueryDetails(queryId: String) async throws -> QuizQueryAnswerResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        let survey = try await withCheckedThrowingContinuation { continuation in
            surveyNetworkService.getSurveyForEvent(token: token, eventId: eventId)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
                .store(in: &cancellables)
        }
        return survey
    }

    public func submitAnswers(answers: QuizUserAnswerRequest) async throws {
        let token = try authStorageService.getAccessToken() ?? ""
        let survey = try await withCheckedThrowingContinuation { continuation in
            surveyNetworkService.getSurveyForEvent(token: token, eventId: eventId)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
                .store(in: &cancellables)
        }
        return survey
    }
}