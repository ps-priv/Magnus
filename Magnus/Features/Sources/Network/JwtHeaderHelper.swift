import Alamofire
import Combine
import Foundation

public struct JwtHeaderHelper {

    public static func getJwtHeader(token: String) -> HTTPHeaders {
        var additionalHeaders = HTTPHeaders()

        guard !token.isEmpty else {
            return additionalHeaders
        }

        additionalHeaders.add(.authorization(bearerToken: token))

        return additionalHeaders
    }
}
