import Alamofire
import Combine
import Foundation
import MagnusApplication
import MagnusDomain

public class ApiAuthService: AuthService {
    private var currentUser: AuthUser?
    private var currentToken: String?
    private var isUserAuthenticated: Bool = false
    private var cancellables = Set<AnyCancellable>()

    private let authNetworkService: AuthNetworkServiceProtocol
    private let authStorageService: AuthStorageService

    public init(authNetworkService: AuthNetworkServiceProtocol,
                authStorageService: AuthStorageService) {
        self.authNetworkService = authNetworkService
        self.authStorageService = authStorageService
    }

    public func login(credentials: LoginCredentials) async throws -> AuthResponse {
        // Simulate network delay
        //try await Task.sleep(nanoseconds: 2_000_000_000)  // 1 second
        // Validate email format
        guard isValidPassword(credentials.password) else {
            throw AuthError.passwordTooShort
        }

        let loginRequest = LoginRequest(
            email: credentials.email,
            password: credentials.password
        )

        let loginResponse = try await withCheckedThrowingContinuation { continuation in
            authNetworkService.login(request: loginRequest)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { response in
                        continuation.resume(returning: response)
                    }
                )
                .store(in: &self.cancellables)
        }

        currentUser = AuthUser(
            id: loginResponse.user.id,
            email: loginResponse.user.email,
            firstName: loginResponse.user.firstName,
            lastName: loginResponse.user.lasName,
            role: CurrentUserTypeEnum(rawValue: loginResponse.user.role) ?? .uczestnik,
            admin: loginResponse.user.admin,
            news_editor: loginResponse.user.news_editor,
            photo_booths_editor: loginResponse.user.photo_booths_editor
        )

        currentToken = loginResponse.token
        isUserAuthenticated = true

        return AuthResponse(
            token: loginResponse.token,
            refreshToken: loginResponse.token,
            user: currentUser!
        )
    }

    public func logout() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)  // 0.5 seconds

        // Clear internal state
        currentUser = nil
        currentToken = nil
        isUserAuthenticated = false
    }

    // public func refreshToken(_ refreshToken: String) async throws -> AuthResponse {
    //     // // Simulate network delay
    //     // try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

    //     // guard refreshToken == mockRefreshToken else {
    //     //     throw AuthError.invalidCredentials
    //     // }

    //     // guard let user = currentUser else {
    //     //     throw AuthError.userNotFound
    //     // }

    //     // // Generate new mock token
    //     // let newToken = "refreshed_\(mockToken)_\(Date().timeIntervalSince1970)"
    //     // currentToken = newToken

    //     // return AuthResponse(
    //     //     token: newToken,
    //     //     refreshToken: mockRefreshToken,
    //     //     user: user
    //     // )
    // }

    public func isValidEmail(_ email: String) -> Bool {
        return EmailValidator.isValid(email)
    }

    public func isValidPassword(_ password: String) -> Bool {
        return PasswordValidator.isValid(password)
    }

    public func isAuthenticated() -> Bool {
        return currentToken != nil && currentUser != nil
    }

    public func getCurrentToken() -> String? {
        return currentToken
    }

    public func getCurrentUser() -> AuthUser? {
        return currentUser
    }



    public func getUserProfile() async throws -> UserProfileResponse {
        
        let token = try authStorageService.getAccessToken() ?? ""
        
        let userProfile = try await withCheckedThrowingContinuation { continuation in
            authNetworkService.getUserProfile(token: token)
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
        return userProfile

    }

    public func updateUserProfile(request: UserProfileUpdateRequest) async throws {
        let token = try authStorageService.getAccessToken() ?? ""

        let updatedProfile = try await withCheckedThrowingContinuation { continuation in
            authNetworkService.updateUserProfile(token: token, request: request)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { response in
                        continuation.resume(returning: response)
                    }
                )
                .store(in: &self.cancellables)
        }
    }
    
    public func changePassword(currentPassword: String, newPassword: String) async throws {
        let token = try authStorageService.getAccessToken() ?? ""
        
        let request = PasswordChangeRequest(
            currentPassword: currentPassword,
            password: newPassword,
            passwordConfirmation: newPassword
        )
        
        try await withCheckedThrowingContinuation { continuation in
            authNetworkService.changePassword(token: token, request: request)
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
                        // No value expected
                    }
                )
                .store(in: &self.cancellables)
        }
    }
    
    public func forgetPassword(email: String) async throws {
        let request = ForgetPasswordRequest(email: email)
        
        try await withCheckedThrowingContinuation { continuation in
            authNetworkService.forgetPassword(request: request)
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
                        // No value expected
                    }
                )
                .store(in: &self.cancellables)
        }
    }
    
    public func resetPassword(email: String, code: String, password: String, passwordConfirmation: String) async throws {
        let request = ResetPasswordRequest(
            email: email,
            code: code,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
        
        try await withCheckedThrowingContinuation { continuation in
            authNetworkService.resetPassword(request: request)
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
                        // No value expected
                    }
                )
                .store(in: &self.cancellables)
        }
    }
}
