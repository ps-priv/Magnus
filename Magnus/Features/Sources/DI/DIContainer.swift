import Swinject
import MagnusCore

public class DIContainer {
    public static let shared = DIContainer()
    private let container = Container()
    
    private init() {}
    
    public func configure(with applicationType: ApplicationContainerTypeEnum) {
        // switch applicationType {
        // // case .novonordisk:
        // //     // container.register(UserRepositoryProtocol.self) { _ in
        // //     //     UserRepository()
        // //     // }.inObjectScope(.container)
        // // case .chm:
        // //     // container.register(UserRepositoryProtocol.self) { _ in
        // //     //     UserRepositoryCartoon()
        // //     // }.inObjectScope(.container)
        // }
        
//        container.register(UserListViewModel.self) { resolver in
//            UserListViewModel(userRepository: resolver.resolve(UserRepositoryProtocol.self)!)
//        }
    }
    
    public func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}