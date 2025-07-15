import Swinject
import MagnusDomain
import MagnusApplication

public class DIContainer {
    public static let shared = DIContainer()
    private let container = Container()
    
    private init() {}
    
    public func configure(with applicationType: ApplicationContainerTypeEnum) {
        // Register AuthService based on application type
        switch applicationType {
        case .novonordisk:
            // Register mock AuthService for NovoNordisk app
            container.register(AuthService.self) { _ in
                AuthServiceMock()
            }.inObjectScope(.container)
            
            // Register real AuthStorageService for iOS
            container.register(AuthStorageService.self) { _ in
                IosAuthStorageService()
            }.inObjectScope(.container)
            
            // Register mock DashboardService
            container.register(DashboardService.self) { _ in
                DashboardServiceMock()
            }.inObjectScope(.container)
            
        case .chm:
            // Register mock AuthService for ChM app  
            container.register(AuthService.self) { _ in
                AuthServiceMock()
            }.inObjectScope(.container)
            
            // Register real AuthStorageService for iOS
            container.register(AuthStorageService.self) { _ in
                IosAuthStorageService()
            }.inObjectScope(.container)
            
            // Register mock DashboardService
            container.register(DashboardService.self) { _ in
                DashboardServiceMock()
            }.inObjectScope(.container)
        }
        
        // Register other services here as needed
        // container.register(UserListViewModel.self) { resolver in
        //     UserListViewModel(userRepository: resolver.resolve(UserRepositoryProtocol.self)!)
        // }
    }
    
    public func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
