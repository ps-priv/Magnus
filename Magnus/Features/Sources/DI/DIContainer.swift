import Combine
import Foundation
import MagnusApplication
import MagnusDomain
import Network
import SwiftUI
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

        // Register Network Monitor
        container.register(NetworkMonitorProtocol.self) { _ in
            let monitor = NetworkMonitor()
            monitor.startMonitoring()
            return monitor
        }.inObjectScope(.container)

        // Register Network Status ViewModel
        container.register(NetworkStatusViewModel.self) { resolver in
            let networkMonitor = resolver.resolve(NetworkMonitorProtocol.self)!
            return NetworkStatusViewModel(networkMonitor: networkMonitor)
        }.inObjectScope(.container)

        container.register(AuthNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return AuthNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(DashboardNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return DashboardNetworkService(networkService: networkService)
        }.inObjectScope(.container)
 
        container.register(NewsNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return NewsNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(EventsNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return EventsNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(MaterialsNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return MaterialsNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(MessagesNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return MessagesNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(AcademyNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return AcademyNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(SurveyNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return SurveyNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        container.register(QuizNetworkServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return QuizNetworkService(networkService: networkService)
        }.inObjectScope(.container)

        // Register AuthService based on application type
        switch applicationType {
        case .novonordisk:
            // Register mock AuthService for NovoNordisk app
            container.register(AuthService.self) { resolver in
                let networkService = resolver.resolve(AuthNetworkServiceProtocol.self)!
                let authStorageService = resolver.resolve(AuthStorageService.self)!
                return ApiAuthService(authNetworkService: networkService,
                                      authStorageService: authStorageService)
            }.inObjectScope(.container)

            // Register real AuthStorageService for iOS
            container.register(AuthStorageService.self) { _ in
                IosAuthStorageService()
            }.inObjectScope(.container)

            container.register(MagnusStorageService.self) { _ in
                IosStorageService()
            }.inObjectScope(.container)

            container.register(DashboardService.self) { resolver in
                let authStorageService = resolver.resolve(AuthStorageService.self)!
                let dashboardNetworkService = resolver.resolve(
                    DashboardNetworkServiceProtocol.self)!
                return ApiDashboardService(
                    authStorageService: authStorageService,
                    dashboardNetworkService: dashboardNetworkService)
            }.inObjectScope(.container)

            container.register(ApiNewsService.self) { resolver in
                let authStorageService = resolver.resolve(AuthStorageService.self)!
                let newsNetworkService = resolver.resolve(NewsNetworkServiceProtocol.self)!
                return ApiNewsService(
                    authStorageService: authStorageService,
                    newsNetworkService: newsNetworkService)
            }.inObjectScope(.container)

            container.register(ApiEventsService.self) { resolver in
                let eventsNetworkService = resolver.resolve(EventsNetworkServiceProtocol.self)!
                let authStorageService = resolver.resolve(AuthStorageService.self)!
                return ApiEventsService(
                    eventsNetworkService: eventsNetworkService,
                    authStorageService: authStorageService)
            }.inObjectScope(.container)

            container.register(ApiMaterialsService.self) { resolver in
                let materialsNetworkService = resolver.resolve(MaterialsNetworkServiceProtocol.self)!
                let authStorageService = resolver.resolve(AuthStorageService.self)!
                return ApiMaterialsService(
                    materialsNetworkService: materialsNetworkService,
                    authStorageService: authStorageService)
            }.inObjectScope(.container)

            container.register(ApiMessagesService.self) { resolver in
                let messagesNetworkService = resolver.resolve(MessagesNetworkServiceProtocol.self)!
                let authStorageService = resolver.resolve(AuthStorageService.self)!
                return ApiMessagesService(
                    messagesNetworkService: messagesNetworkService,
                    authStorageService: authStorageService)
            }.inObjectScope(.container)

            container.register(ApiAcademyService.self) { resolver in
                let academyNetworkService = resolver.resolve(AcademyNetworkServiceProtocol.self)!    
                let authStorageService = resolver.resolve(AuthStorageService.self)!    
                return ApiAcademyService(
                    academyNetworkService: academyNetworkService,
                    authStorageService: authStorageService)
            }.inObjectScope(.container)

            container.register(ApiSurveyService.self) { resolver in
                let surveyNetworkService = resolver.resolve(SurveyNetworkServiceProtocol.self)!    
                let authStorageService = resolver.resolve(AuthStorageService.self)!    
                return ApiSurveyService(
                    surveyNetworkService: surveyNetworkService,
                    authStorageService: authStorageService)
            }.inObjectScope(.container)

            container.register(ApiQuizService.self) { resolver in
                let quizNetworkService = resolver.resolve(QuizNetworkServiceProtocol.self)!    
                let authStorageService = resolver.resolve(AuthStorageService.self)!    
                return ApiQuizService(
                    quizNetworkService: quizNetworkService,
                    authStorageService: authStorageService)
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
