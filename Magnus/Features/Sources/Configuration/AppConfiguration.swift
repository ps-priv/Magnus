import Foundation

public struct AppConfiguration {

    // MARK: - Singleton
    public static let shared = AppConfiguration()

    /// Whether Sentry error reporting is enabled
    public var isSentryErrorReportingEnabled: Bool = true

    /// Whether Sentry debug mode is enabled
    public var isSentryDebugModeEnabled: Bool = true
}
