import Alamofire
import Combine
import Foundation

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
