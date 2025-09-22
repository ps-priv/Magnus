import Combine
import MagnusDomain

public protocol SurveyNetworkServiceProtocol {
    func getSurveyForEvent(token: String, eventId: String) -> AnyPublisher<SurveyForEvent, Error>
    func getSurveyQueryDetails(token: String, queryId: String) -> AnyPublisher<SurveyQueryDetails, Error>
    func submitAnswers(token: String, answers: SurveyAnswer) -> AnyPublisher<Void, Error>
}

public class SurveyNetworkService: SurveyNetworkServiceProtocol {
    
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getSurveyForEvent(token: String, eventId: String) -> AnyPublisher<SurveyForEvent, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/survey/\(eventId)",
            method: .get,
            responseType: SurveyForEvent.self,
            bearerToken: token
        )
    }

    public func getSurveyQueryDetails(token: String, queryId: String) -> AnyPublisher<SurveyQueryDetails, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/survey/query/\(queryId)",
            method: .get,
            responseType: SurveyQueryDetails.self,
            bearerToken: token
        )
    }

    public func submitAnswers(token: String, answers: SurveyAnswer) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/survey/user-answer",
            method: .post,
            headers: nil,
            body: answers,
            bearerToken: token
        )
    }
}
