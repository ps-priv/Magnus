import Foundation
import MagnusDomain

public extension DIContainer {
    
    // MARK: - Auth Services
    
    /// Returns registered AuthService instance
    var authService: AuthService {
        guard let service = resolve(AuthService.self) else {
            fatalError("AuthService not registered in DI container")
        }
        return service
    }
    
    // MARK: - Convenience Methods
    
    /// Returns AuthService as specific type for testing
    func authServiceMock() -> AuthServiceMock? {
        return resolve(AuthService.self) as? AuthServiceMock
    }
} 