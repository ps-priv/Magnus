import Alamofire
import Combine
import Foundation
import MagnusDomain

public protocol NewsNetworkServiceProtocol {
    func getNews(token: String) -> AnyPublisher<GetNewsResponse, Error>
    func getNewsInGroup(token: String, groupId: String) -> AnyPublisher<GetNewsResponse, Error>
    func getNewsById(token: String, id: String) -> AnyPublisher<NewsDetails, Error>
    func changeNewsBookmarkStatus(token: String, id: String) -> AnyPublisher<Void, Error>
    func sendReaction(token: String, id: String, reaction: ReactionEnum) -> AnyPublisher<Void, Error>
    func markNewsAsRead(token: String, id: String) -> AnyPublisher<Void, Error>
    func addCommentToNews(token: String, id: String, comment: String) -> AnyPublisher<Void, Error>
    func getGroups(token: String) -> AnyPublisher<GetGroupsResponse, Error>
    func addNews(token: String, title: String, content: String, image: String, selectedGroups: [NewsGroup], attachments: [NewsAttachment], tags: [String], allow_comments: Bool) -> AnyPublisher<Void, Error>
    func updateNews(token: String, id: String, title: String, content: String, image: String, selectedGroups: [NewsGroup], attachments: [NewsAttachment], tags: [String], allow_comments: Bool) -> AnyPublisher<Void, Error>
    func deleteNews(token: String, id: String) -> AnyPublisher<Void, Error>
}

public class NewsNetworkService: NewsNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getNews(token: String) -> AnyPublisher<GetNewsResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news",
            method: .get,
            responseType: GetNewsResponse.self,
            bearerToken: token
        )
    }

    public func getNewsInGroup(token: String, groupId: String) -> AnyPublisher<GetNewsResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news/groups/\(groupId)",
            method: .get,
            responseType: GetNewsResponse.self,
            bearerToken: token
        )
    }

    public func getNewsById(token: String, id: String) -> AnyPublisher<NewsDetails, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)",
            method: .get,
            responseType: NewsDetails.self,
            bearerToken: token
        )
    }

    public func changeNewsBookmarkStatus(token: String, id: String) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)/bookmark",
            method: .post,
            bearerToken: token
        )
    }

    public func sendReaction(token: String, id: String, reaction: ReactionEnum) -> AnyPublisher<Void, Error> {
        let parameters: [String: Any] = [
            "reaction_type": reaction.rawValue
        ]

        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)/reaction",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            bearerToken: token
        )
    }

    public func markNewsAsRead(token: String, id: String) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)/read",
            method: .post,
            bearerToken: token
        )
    }

    public func addCommentToNews(token: String, id: String, comment: String) -> AnyPublisher<Void, Error> {
        let parameters: [String: Any] = [
            "message": comment
        ]

        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)/comment",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            bearerToken: token
        )
    }

    public func getGroups(token: String) -> AnyPublisher<GetGroupsResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/groups",
            method: .get,
            responseType: GetGroupsResponse.self,
            bearerToken: token
        )
    }

    public func addNews(token: String, title: String, content: String, image: String, selectedGroups: [NewsGroup], attachments: [NewsAttachment], tags: [String], allow_comments: Bool ) -> AnyPublisher<Void, Error> {
        let request = AddNewsRequest(
            title: title,
            message: content,
            image: image,
            tags: tags,
            user_groups: selectedGroups.map { $0.id },
            attachments: attachments,
            allow_comments: allow_comments
        )

        return networkService.requestWithBearerToken(
            endpoint: "/api/news",
            method: .post,
            body: request,
            bearerToken: token
        )
    }

    public func updateNews(token: String, id: String, title: String, content: String, image: String, selectedGroups: [NewsGroup], attachments: [NewsAttachment], tags: [String], allow_comments: Bool) -> AnyPublisher<Void, Error> {
        let request = UpdateNewsRequest(
            id: id,
            title: title,
            message: content,
            image: image,
            tags: tags,
            user_groups: selectedGroups.map { $0.id },
            attachments: attachments,
            allow_comments: allow_comments
        )

        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)",
            method: .put,
            body: request,
            bearerToken: token
        )
    }

    public func deleteNews(token: String, id: String) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/news/\(id)",
            method: .delete,
            bearerToken: token
        )
    }
}
