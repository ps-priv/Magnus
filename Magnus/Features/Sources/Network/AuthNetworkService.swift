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
    public let token: String
    public let user: UserDto

    public init(token: String, user: UserDto) {
        self.token = token
        self.user = user
    }
}

public struct UserDto: Codable {
    public let id: String
    public let email: String
    public let firstName: String
    public let lasName: String
    public let role: Int

    public init(id: String, email: String, firstName: String, lasName: String, role: Int) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lasName = lasName
        self.role = role
    }
}

public protocol AuthNetworkServiceProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error>
    // func logout() -> AnyPublisher<Void, Error>
    // func refreshToken(refreshToken: String) -> AnyPublisher<LoginResponse, Error>
}

public class AuthNetworkService: AuthNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {

        // Konwersja na Dictionary
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(request),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return Fail(error: NSError(domain: "EncodingError", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }

        return networkService.request(
            endpoint: "/api/auth/login",
            method: .post,
            parameters: json,
            encoding: JSONEncoding.default,
            responseType: LoginResponse.self
        )
    }

    // public func logout() -> AnyPublisher<Void, Error> {
    //     return networkService.request(
    //         endpoint: "/api/auth/logout",
    //         method: .post,
    //         parameters: nil,
    //         encoding: URLEncoding.default
    //     )
    // }

    // public func refreshToken(refreshToken: String) -> AnyPublisher<LoginResponse, Error> {
    //     return networkService.request(
    //         endpoint: "/api/auth/refresh",
    //         method: .post,
    //         parameters: ["refreshToken": refreshToken],
    //         encoding: JSONEncoding.default,
    //         responseType: LoginResponse.self
    //     )
    // }
}
