import MagnusDomain
import Sentry

public class SentryHelper {
    public static func capture(message: String) {
        // Check if Sentry error reporting is enabled
        guard AppConfiguration.shared.isSentryErrorReportingEnabled else {
            print("Sentry error reporting is disabled. Message: \(message)")
            return
        }

        SentrySDK.capture(message: message)
    }

    public static func capture(error: Error, action: String) {
        // Check if Sentry error reporting is enabled
        guard AppConfiguration.shared.isSentryErrorReportingEnabled else {
            print("Sentry error reporting is disabled. Error: \(error), Action: \(action)")
            return
        }

        if let authError = error as? AuthError {
            SentrySDK.capture(message: "[AuthError] \(action): \(authError)")
        } else {
            SentrySDK.capture(message: "[GenericError] \(action): \(error)")
        }
    }
}
