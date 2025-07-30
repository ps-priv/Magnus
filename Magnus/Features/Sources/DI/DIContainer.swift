import Combine
import Foundation
import MagnusApplication
import MagnusDomain
import Swinject

public class DIContainer {
    public static let shared = DIContainer()
    private let container = Container()

    private init() {}

    public func configure(
        with applicationType: ApplicationContainerTypeEnum, apiBaseURL: String? = nil
    ) {
        // Register Network Configuration
        let networkConfig = NetworkConfiguration(
            baseURL: apiBaseURL ?? "https://api.magnus.com"
        )
        container.register(NetworkConfiguration.self) { _ in
            networkConfig
        }.inObjectScope(.container)

        // Register Network Service
        container.register(NetworkServiceProtocol.self) { resolver in
            let config = resolver.resolve(NetworkConfiguration.self)!
            return NetworkService(configuration: config)
        }.inObjectScope(.container)

        // Register Network Services
        container.register(AcademyNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return AcademyNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(EventsNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return EventsNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(AuthNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return AuthNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        // Register Academy Service
        container.register(AcademyServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(AcademyNetworkServiceProtocol.self)!
            return AcademyService(networkService: networkService)
        }.inObjectScope(.container)

        // Register AuthService based on application type
        switch applicationType {
        case .novonordisk:
            // Register mock AuthService for NovoNordisk app
            container.register(AuthService.self) { resolver in
                let networkService = resolver.resolve(AuthNetworkServiceProtocol.self)!
                return ApiAuthService(authNetworkService: networkService)
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
