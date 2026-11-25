import Combine
import Foundation
import MagnusDomain

public class ApiAgendaAssessmentService: AgendaAssessmentService {
    private let agendaAssessmentNetworkService: AgendaAssessmentNetworkServiceProtocol
    private let authStorageService: AuthStorageService

    public init(agendaAssessmentNetworkService: AgendaAssessmentNetworkServiceProtocol, authStorageService: AuthStorageService) {
        self.agendaAssessmentNetworkService = agendaAssessmentNetworkService
        self.authStorageService = authStorageService
    }

    public func submitAssessment(_ request: AgendaAssessmentRequest) async throws {
        let token = try authStorageService.getAccessToken() ?? ""
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            var cancellable: AnyCancellable?
            var resumed = false
            cancellable = agendaAssessmentNetworkService.submitAssessment(token: token, request: request)
                .sink(
                    receiveCompletion: { completion in
                        if !resumed {
                            switch completion {
                            case .finished:
                                continuation.resume()
                            case .failure(let error):
                                continuation.resume(throwing: error)
                            }
                            resumed = true
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { _ in
                        if !resumed {
                            continuation.resume()
                            resumed = true
                        }
                        cancellable?.cancel()
                    }
                )
        }
    }
}
