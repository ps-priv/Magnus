import Foundation
import MagnusDomain

/// Mock do podglądów SwiftUI i testów – nie wykonuje wywołań sieciowych.
public final class AgendaAssessmentServiceMock: AgendaAssessmentService {
    public var error: Error?
    public var delay: Duration
    public private(set) var submittedRequests: [AgendaAssessmentRequest] = []

    public init(error: Error? = nil, delay: Duration = .seconds(1)) {
        self.error = error
        self.delay = delay
    }

    public func submitAssessment(_ request: AgendaAssessmentRequest) async throws {
        submittedRequests.append(request)
        try await Task.sleep(for: delay)
        if let error { throw error }
    }
}
