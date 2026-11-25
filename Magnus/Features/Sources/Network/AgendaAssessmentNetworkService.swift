import Combine
import MagnusDomain

public protocol AgendaAssessmentNetworkServiceProtocol {
    func submitAssessment(token: String, request: AgendaAssessmentRequest) -> AnyPublisher<Void, Error>
}

public class AgendaAssessmentNetworkService: AgendaAssessmentNetworkServiceProtocol {

    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func submitAssessment(token: String, request: AgendaAssessmentRequest) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/agenda/assessment",
            method: .post,
            headers: nil,
            body: request,
            bearerToken: token
        )
    }
}
