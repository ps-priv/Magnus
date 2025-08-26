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
        let news = try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.getNews(token: token)
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

    public func getBookmarks() async throws -> GetNewsResponse {
        var response: GetNewsResponse = try await getNews()
        let news = response.news.filter { $0.isBookmarked }
        return GetNewsResponse(news: news)
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

    public func sendNewsReaction(id: String, reaction: ReactionEnum) async throws -> Void {
        let token = try authStorageService.getAccessToken() ?? ""
        try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.sendReaction(token: token, id: id, reaction: reaction)
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

    public func markNewsAsRead(id: String) async throws -> Void {
        let token = try authStorageService.getAccessToken() ?? ""
        try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.markNewsAsRead(token: token, id: id)
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

    public func addCommentToNews(id: String, comment: String) async throws -> Void {
        let token = try authStorageService.getAccessToken() ?? ""
        try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.addCommentToNews(token: token, id: id, comment: comment)
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

    public func getGroups() async throws -> GetGroupsResponse {
        let token = try authStorageService.getAccessToken() ?? ""
        let groups = try await withCheckedThrowingContinuation { continuation in
            newsNetworkService.getGroups(token: token)
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
        return groups
    }

    public func addNews(title: String, content: String, image: Data?, selectedGroups: [NewsGroup], attachments: [NewsAttachment], tags: [String]) async throws -> Void {
        let token = try authStorageService.getAccessToken() ?? ""

        let imageString = ImageToBase64Converter.convert(imageData: image ?? Data()) ?? ""

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            newsNetworkService.addNews(token: token, title: title, content: content, image: imageString, selectedGroups: selectedGroups, attachments: attachments, tags: tags)
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

    public func updateNews(id: String, title: String, content: String, image: Data?, selectedGroups: [NewsGroup], attachments: [NewsAttachment], tags: [String]) async throws -> Void { 
        let token = try authStorageService.getAccessToken() ?? ""

        let imageString = ImageToBase64Converter.convert(imageData: image ?? Data()) ?? ""

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            newsNetworkService.updateNews(token: token, id: id, title: title, content: content, image: imageString, selectedGroups: selectedGroups, attachments: attachments, tags: tags)
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