import Foundation
import Alamofire

public struct ApiError {
    public let message: String
    public let statusCode: Int

    public init(message: String, statusCode: Int) {
        self.message = message
        self.statusCode = statusCode
    }

    public static func from(error: Error) -> ApiError {
        if let error = error as? AFError {
            return ApiError(message: error.localizedDescription, statusCode: error.responseCode ?? 500)
        }

        return ApiError(message: "Unknown error", statusCode: 500)
    }

    public func isUnauthorized() -> Bool {
        return statusCode == 401
    }

    public func isForbidden() -> Bool {
        return statusCode == 403
    }

    public func isNotFound() -> Bool {
        return statusCode == 404
    }

    public func isBadRequest() -> Bool {
        return statusCode == 400
    }
    
    public func isInternalServerError() -> Bool {
        return statusCode == 500
    }

    public func isServiceUnavailable() -> Bool {
        return statusCode == 503
    }
    
}