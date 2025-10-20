import Foundation
import Combine
import MagnusDomain

public class ApiQuizService: QuizService {
    private let quizNetworkService: QuizNetworkServiceProtocol
    private let authStorageService: AuthStorageService

    public init(quizNetworkService: QuizNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.quizNetworkService = quizNetworkService
        self.authStorageService = authStorageService
    }

    public func getQuizForAgenda(agendaId: String) async throws -> QuizForEvent {
        let token = try authStorageService.getAccessToken() ?? ""
        let survey = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<QuizForEvent, Error>) in
            var cancellable: AnyCancellable?
            cancellable = quizNetworkService.getQuizForAgenda(token: token, agendaId: agendaId)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                    }
                )
        }
        return survey
    }

    public func getQuizQueryDetails(queryId: String) async throws -> QuizQueryAnswerResponse {
        print("[ApiQuizService] getQuizQueryDetails called for: \(queryId)")
        let token = try authStorageService.getAccessToken() ?? ""
        let survey = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<QuizQueryAnswerResponse, Error>) in
            var cancellable: AnyCancellable?
            print("[ApiQuizService] Starting network request for: \(queryId)")
            cancellable = quizNetworkService.getQuizQueryDetails(token: token, queryId: queryId)
                .sink(
                    receiveCompletion: { completion in
                        print("[ApiQuizService] Received completion for: \(queryId)")
                        switch completion {
                        case .finished:
                            print("[ApiQuizService] Finished successfully for: \(queryId)")
                            break
                        case .failure(let error):
                            print("[ApiQuizService] Error for \(queryId): \(error.localizedDescription)")
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        print("[ApiQuizService] Received value for: \(queryId), text: \(value.query_text)")
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                    }
                )
        }
        print("[ApiQuizService] Returning survey for: \(queryId)")
        return survey
    }

    public func submitAnswers(answers: QuizUserAnswerRequest) async throws {
        let token = try authStorageService.getAccessToken() ?? ""
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            var cancellable: AnyCancellable?
            cancellable = quizNetworkService.submitAnswers(token: token, answer: answers)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            continuation.resume()
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        cancellable?.cancel()
                    }
                )
        }
    }
}
