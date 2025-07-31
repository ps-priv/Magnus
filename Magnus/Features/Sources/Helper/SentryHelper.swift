import MagnusDomain
import Sentry

public class SentryHelper {
    public static func capture(message: String) {
        SentrySDK.capture(message: message)
    }

    public static func capture(error: Error, action: String) {
        if let authError = error as? AuthError {
            SentrySDK.capture(message: "[AuthError] \(action): \(authError)")
        } else {
            SentrySDK.capture(message: "[GenericError] \(action): \(error)")
        }
    }
}
