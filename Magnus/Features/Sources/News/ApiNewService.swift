import Foundation
import Combine
import MagnusDomain

public class ApiNewsService: NewsServiceProtocol {

    private let authStorageService: AuthStorageService
    private let newsNetworkService: NewsNetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(
        authStorageService: AuthStorageService,
        newsNetworkService: NewsNetworkServiceProtocol
    ) {
        self.authStorageService = authStorageService
        self.newsNetworkService = newsNetworkService
    }


    public func getNews() async throws -> GetNewsResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        print("token: \(token)")
        let news = try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.getNews(token: token)
                .sink(
                    receiveCompletion: { completion in
                        print("completion: \(completion)")
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
        print("news: \(news)")
        return news
    }

    public func getNewsById(id: String) async throws -> NewsDetails {
        let token = try authStorageService.getAccessToken() ?? ""
        let news = try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.getNewsById(token: token, id: id)
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
        return news
    }

    public func changeNewsBookmarkStatus(id: String) async throws -> Void {
        let token = try authStorageService.getAccessToken() ?? ""
        try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.changeNewsBookmarkStatus(token: token, id: id)
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