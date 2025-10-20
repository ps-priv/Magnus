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
    public let admin: Int
    public let news_editor: Int
    public let photo_booths_editor: Int

    public init(id: String, email: String, firstName: String, lasName: String, role: Int, admin: Int, news_editor: Int, photo_booths_editor: Int) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lasName = lasName
        self.role = role
        self.admin = admin
        self.news_editor = news_editor
        self.photo_booths_editor = photo_booths_editor
    }
}

public struct PasswordChangeRequest: Codable {
    public let currentPassword: String
    public let password: String
    public let passwordConfirmation: String

    public init(currentPassword: String, password: String, passwordConfirmation: String) {
        self.currentPassword = currentPassword
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
    
    enum CodingKeys: String, CodingKey {
        case currentPassword = "current_password"
        case password = "password"
        case passwordConfirmation = "password_confirmation"
    }
}

public struct ForgetPasswordRequest: Codable {
    public let email: String

    public init(email: String) {
        self.email = email
    }
}

public struct APIErrorResponse: Codable {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

public protocol AuthNetworkServiceProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error>

    func getUserProfile(token: String) -> AnyPublisher<UserProfileResponse, Error>

    func updateUserProfile(token: String, request: UserProfileUpdateRequest) -> AnyPublisher<Void, Error>
    
    func changePassword(token: String, request: PasswordChangeRequest) -> AnyPublisher<Void, Error>
    
    func forgetPassword(request: ForgetPasswordRequest) -> AnyPublisher<Void, Error>
    
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
            headers: nil,
            parameters: json,
            encoding: JSONEncoding.default,
            responseType: LoginResponse.self,
            bearerToken: nil
        )
    }

    public func getUserProfile(token: String) -> AnyPublisher<UserProfileResponse, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/user",
            method: .get,
            responseType: UserProfileResponse.self,
            bearerToken: token
        )
    }

    public func updateUserProfile(token: String, request: UserProfileUpdateRequest) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/user",
            method: .put,
            headers: nil,
            body: request,
            bearerToken: token
        )
    }
    
    public func changePassword(token: String, request: PasswordChangeRequest) -> AnyPublisher<Void, Error> {
        return networkService.requestWithBearerToken(
            endpoint: "/api/user/change_password",
            method: .put,
            headers: nil,
            body: request,
            bearerToken: token
        )
    }
    
    public func forgetPassword(request: ForgetPasswordRequest) -> AnyPublisher<Void, Error> {
        // Convert to Dictionary
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(request),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return Fail(error: NSError(domain: "EncodingError", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }

        return networkService.request(
            endpoint: "/api/auth/forget_password",
            method: .post,
            headers: nil,
            parameters: json,
            encoding: JSONEncoding.default,
            bearerToken: nil
        )
    }

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
