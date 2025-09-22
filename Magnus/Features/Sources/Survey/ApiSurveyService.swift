import Foundation
import Combine
import MagnusDomain

public class ApiSurveyService: SurveyService {
    private let surveyNetworkService: SurveyNetworkServiceProtocol
    private let authStorageService: AuthStorageService
    private var cancellables = Set<AnyCancellable>()

    public init(surveyNetworkService: SurveyNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.surveyNetworkService = surveyNetworkService
        self.authStorageService = authStorageService
    }

    public func getSurveyForEvent(eventId: String) async throws -> SurveyForEvent {
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

    public func getSurveyQueryDetails(queryId: String) async throws -> SurveyQueryDetails {
        let token = try authStorageService.getAccessToken() ?? ""
        let survey = try await withCheckedThrowingContinuation { continuation in
            surveyNetworkService.getSurveyQueryDetails(token: token, queryId: queryId)
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

    public func submitAnswers(answers: SurveyAnswer) async throws {
        let token = try authStorageService.getAccessToken() ?? ""
        
        // do {
        //     let jsonData = try JSONEncoder().encode(answers)
        //     if let jsonString = String(data: jsonData, encoding: .utf8) {
        //         print("SurveyAnswer JSON: \(jsonString)")
        //     }
        // } catch {
        //     print("Failed to encode SurveyAnswer to JSON: \(error)")
        // }

        try await withCheckedThrowingContinuation { continuation in
            surveyNetworkService.submitAnswers(token: token, answers: answers)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            continuation.resume(returning: ())
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { _ in
                        // Void response, nothing to do
                    }
                )
                .store(in: &cancellables)
        }
    }
}   