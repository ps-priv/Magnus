import Alamofire
import Combine
import Foundation
import MagnusDomain

public struct LoginRequest: Codable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct LoginResponse: Codable {
    public let accessToken: String
    public let refreshToken: String
    public let user: User

    public init(accessToken: String, refreshToken: String, user: User) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.user = user
    }
}

public struct User: Codable {
    public let id: String
    public let email: String
    public let name: String
    public let role: String

    public init(id: String, email: String, name: String, role: String) {
        self.id = id
        self.email = email
        self.name = name
        self.role = role
    }
}

public protocol AuthNetworkServiceProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error>
    func logout() -> AnyPublisher<Void, Error>
    func refreshToken(refreshToken: String) -> AnyPublisher<LoginResponse, Error>
}

public class AuthNetworkService: AuthNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return networkService.request(
            endpoint: "/api/auth/login",
            method: .post,
            parameters: [
                "email": request.email,
                "password": request.password,
            ],
            encoding: JSONEncoding.default,
            responseType: LoginResponse.self
        )
    }

    public func logout() -> AnyPublisher<Void, Error> {
        return networkService.request(
            endpoint: "/api/auth/logout",
            method: .post,
            parameters: nil,
            encoding: URLEncoding.default
        )
    }

    public func refreshToken(refreshToken: String) -> AnyPublisher<LoginResponse, Error> {
        return networkService.request(
            endpoint: "/api/auth/refresh",
            method: .post,
            parameters: ["refreshToken": refreshToken],
            encoding: JSONEncoding.default,
            responseType: LoginResponse.self
        )
    }
}
