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
    
    /// Returns registered AuthStorageService instance
    var authStorageService: AuthStorageService {
        guard let service = resolve(AuthStorageService.self) else {
            fatalError("AuthStorageService not registered in DI container")
        }
        return service
    }

    /// Returns registered MagnusStorageService instance
    var storageService: MagnusStorageService {
        guard let service = resolve(MagnusStorageService.self) else {
            fatalError("MagnusStorageService not registered in DI container")
        }
        return service
    }
    
    /// Returns registered DashboardService instance
    var dashboardService: DashboardService {
        guard let service = resolve(DashboardService.self) else {
            fatalError("DashboardService not registered in DI container")
        }
        return service
    }
    
    /// Returns registered NewsService instance
    var newsService: ApiNewsService {
        guard let service = resolve(ApiNewsService.self) else {
            fatalError("ApiNewsService not registered in DI container")
        }
        return service
    }

    /// Returns registered EventsService instance
    var eventsService: ApiEventsService {
        guard let service = resolve(ApiEventsService.self) else {
            fatalError("ApiEventsService not registered in DI container")
        }
        return service
    }

    /// Returns registered MaterialsService instance
    var materialsService: ApiMaterialsService {
        guard let service = resolve(ApiMaterialsService.self) else {
            fatalError("ApiMaterialsService not registered in DI container")
        }
        return service
    }
    
    // MARK: - Convenience Methods
    
    /// Returns AuthService as specific type for testing
    func authServiceMock() -> AuthServiceMock? {
        return resolve(AuthService.self) as? AuthServiceMock
    }
    
    /// Returns AuthStorageService as specific type for testing
    func authStorageServiceMock() -> AuthStorageServiceMock? {
        return resolve(AuthStorageService.self) as? AuthStorageServiceMock
    }
    
    /// Returns DashboardService as specific type for testing
    func dashboardServiceMock() -> DashboardServiceMock? {
        return resolve(DashboardService.self) as? DashboardServiceMock
    }
} 