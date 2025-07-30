import Alamofire
import Foundation

public struct NetworkConfiguration {
    public let baseURL: String
    public let timeoutInterval: TimeInterval
    public let headers: HTTPHeaders

    public init(
        baseURL: String,
        timeoutInterval: TimeInterval = 30.0,
        headers: HTTPHeaders = HTTPHeaders()
    ) {
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
        self.headers = headers
    }

    public static let `default` = NetworkConfiguration(
        baseURL: "https://api.magnus.com",
        headers: HTTPHeaders([
            "Content-Type": "application/json",
            "Accept": "application/json",
        ])
    )
}
