import Combine
import MagnusDomain

public protocol QuizNetworkServiceProtocol {
    func getQuizForAgenda(token: String, agendaId: String) -> AnyPublisher<QuizForEvent, Error>
    func getQuizQueryDetails(token: String, queryId: String) -> AnyPublisher<QuizQueryAnswerResponse, Error>
    func submitAnswers(token: String, answer: QuizUserAnswerRequest) -> AnyPublisher<Void, Error>
}

public class QuizNetworkService: QuizNetworkServiceProtocol {
    
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getQuizForAgenda(token: String, agendaId: String) -> AnyPublisher<QuizForEvent, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/quiz/\(agendaId)",
            method: .get,
            responseType: QuizForEvent.self,
            bearerToken: token
        )
    }

    public func getQuizQueryDetails(token: String, queryId: String) -> AnyPublisher<QuizQueryAnswerResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/quiz/query/\(queryId)",
            method: .get,
            responseType: QuizQueryAnswerResponse.self,
            bearerToken: token
        )
    }

    public func submitAnswers(token: String, answer: QuizUserAnswerRequest) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/quiz/user-answer",
            method: .post,
            headers: nil,
            body: answer,
            bearerToken: token
        )
    }
}
