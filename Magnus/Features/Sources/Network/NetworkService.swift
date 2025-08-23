import Alamofire
import Combine
import Foundation
import Network
import SwiftUI

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        responseType: T.Type,
        bearerToken: String?
    ) -> AnyPublisher<T, Error>

    func request(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        bearerToken: String?
    ) -> AnyPublisher<Void, Error>

    // New: request with Encodable body (JSON)
    func request<T: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        body: T,
        bearerToken: String?
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
        headers: HTTPHeaders? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        responseType: T.Type,
        bearerToken: String? = nil
    ) -> AnyPublisher<T, Error> {
        let url = configuration.baseURL + endpoint
        
        // Combine default headers with bearer token if provided
        var finalHeaders = self.configuration.headers
        if let customHeaders = headers {
            customHeaders.forEach { header in
                finalHeaders.add(header)
            }
        }
        
        if let token = bearerToken, !token.isEmpty {
            finalHeaders.add(.authorization(bearerToken: token))
        }

        return Future<T, Error> { promise in
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: finalHeaders
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
        headers: HTTPHeaders? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        bearerToken: String? = nil
    ) -> AnyPublisher<Void, Error> {
        let url = configuration.baseURL + endpoint
        
        // Combine default headers with bearer token if provided
        var finalHeaders = self.configuration.headers
        if let customHeaders = headers {
            customHeaders.forEach { header in
                finalHeaders.add(header)
            }
        }
        
        if let token = bearerToken, !token.isEmpty {
            finalHeaders.add(.authorization(bearerToken: token))
        }

        return Future<Void, Error> { promise in
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: finalHeaders
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

    // New: request with Encodable body (JSON)
    public func request<T: Encodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        body: T,
        bearerToken: String? = nil
    ) -> AnyPublisher<Void, Error> {
        let url = configuration.baseURL + endpoint

        // Combine default headers with bearer token if provided
        var finalHeaders = self.configuration.headers
        if let customHeaders = headers {
            customHeaders.forEach { header in
                finalHeaders.add(header)
            }
        }

        if let token = bearerToken, !token.isEmpty {
            finalHeaders.add(.authorization(bearerToken: token))
        }

        return Future<Void, Error> { promise in
            self.session.request(
                url,
                method: method,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: finalHeaders
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

// MARK: - Convenience Extensions

public extension NetworkServiceProtocol {
    /// Convenience method for requests with bearer token
    func requestWithBearerToken<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        responseType: T.Type,
        bearerToken: String
    ) -> AnyPublisher<T, Error> {
        return request(
            endpoint: endpoint,
            method: method,
            headers: headers,
            parameters: parameters,
            encoding: encoding,
            responseType: responseType,
            bearerToken: bearerToken
        )
    }
    
    /// Convenience method for requests with bearer token (no response type)
    func requestWithBearerToken(
        endpoint: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        bearerToken: String
    ) -> AnyPublisher<Void, Error> {
        return request(
            endpoint: endpoint,
            method: method,
            headers: headers,
            parameters: parameters,
            encoding: encoding,
            bearerToken: bearerToken
        )
    }

    /// Convenience method for requests with bearer token and Encodable JSON body
    func requestWithBearerToken<T: Encodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        body: T,
        bearerToken: String
    ) -> AnyPublisher<Void, Error> {
        return request(
            endpoint: endpoint,
            method: method,
            headers: headers,
            body: body,
            bearerToken: bearerToken
        )
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
