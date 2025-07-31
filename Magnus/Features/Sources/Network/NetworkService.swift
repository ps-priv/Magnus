import Alamofire
import Combine
import Foundation
import Network
import SwiftUI

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        responseType: T.Type
    ) -> AnyPublisher<T, Error>

    func request(
        endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding
    ) -> AnyPublisher<Void, Error>
}

public class NetworkService: NetworkServiceProtocol {
    private let configuration: NetworkConfiguration
    private let session: Session

    public init(configuration: NetworkConfiguration) {
        self.configuration = configuration

        let configuration = URLSessionConfiguration.default
        // configuration.timeoutIntervalForRequest = configuration.timeoutInterval
        // configuration.timeoutIntervalForResource = configuration.timeoutInterval

        self.session = Session(configuration: configuration)
    }

    public func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        responseType: T.Type
    ) -> AnyPublisher<T, Error> {
        let url = configuration.baseURL + endpoint

        return Future<T, Error> { promise in
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: self.configuration.headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func request(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) -> AnyPublisher<Void, Error> {
        let url = configuration.baseURL + endpoint

        return Future<Void, Error> { promise in
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: self.configuration.headers
            )
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Network Monitoring

public protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    var connectionStatus: AnyPublisher<Bool, Never> { get }
    func startMonitoring()
    func stopMonitoring()
}

public class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let connectionStatusSubject = CurrentValueSubject<Bool, Never>(true)

    public var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    public var connectionStatus: AnyPublisher<Bool, Never> {
        return connectionStatusSubject.eraseToAnyPublisher()
    }

    public init() {}

    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                self?.connectionStatusSubject.send(isConnected)
            }
        }
        monitor.start(queue: queue)
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    deinit {
        stopMonitoring()
    }
}

// MARK: - Network Status ViewModel

public class NetworkStatusViewModel: ObservableObject {
    @Published public var isConnected: Bool = true
    @Published public var showNoInternetView: Bool = false

    private let networkMonitor: NetworkMonitorProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(networkMonitor: NetworkMonitorProtocol) {
        self.networkMonitor = networkMonitor
        setupBindings()
    }

    private func setupBindings() {
        networkMonitor.connectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isConnected = isConnected
                self?.showNoInternetView = !isConnected
            }
            .store(in: &cancellables)
    }

    public func retryConnection() {
        // Sprawdź ponownie połączenie
        showNoInternetView = !networkMonitor.isConnected
    }
}
