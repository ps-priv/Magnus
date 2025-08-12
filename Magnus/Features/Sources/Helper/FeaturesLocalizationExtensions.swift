import Foundation

extension String {
    /// Returns localized string from Localizable.strings in Features bundle
    var localizedInFeatures: String {
        return NSLocalizedString(self, bundle: Bundle(for: FeaturesLocalizedStrings.self), comment: "")
    }
    
    /// Returns localized string with formatted arguments from Features bundle
    func localizedInFeatures(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, bundle: Bundle(for: FeaturesLocalizedStrings.self), comment: ""), arguments: arguments)
    }
    
    /// Returns localized string from Localizable.strings (legacy method)
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns localized string with formatted arguments (legacy method)
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

// Helper struct for common localized strings
class FeaturesLocalizedStrings {
    
    // MARK: - Bundle Helper
    
    private static var bundle: Bundle {
        return Bundle(for: FeaturesLocalizedStrings.self)
    }
    
    private static func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, bundle: bundle, comment: "")
        if arguments.isEmpty {
            return format
        }
        return String(format: format, arguments: arguments)
    }
    
    // MARK: - Auth Errors
    
    static var invalidCredentials: String {
        return localizedString(for: "AUTH_ERROR_INVALID_CREDENTIALS")
    }
    
    static var invalidEmail: String {
        return localizedString(for: "AUTH_ERROR_INVALID_EMAIL")
    }
    
    static var passwordTooShort: String {
        return localizedString(for: "AUTH_ERROR_PASSWORD_TOO_SHORT")
    }
    
    static func networkError(_ details: String? = nil) -> String {
        if let details = details {
            return localizedString(for: "AUTH_ERROR_NETWORK_ERROR", arguments: details)
        }
        return localizedString(for: "AUTH_ERROR_NETWORK_ERROR")
    }
    
    static var userNotFound: String {
        return localizedString(for: "AUTH_ERROR_USER_NOT_FOUND")
    }
    
    static func serverError(_ code: Int? = nil) -> String {
        if let code = code {
            return localizedString(for: "AUTH_ERROR_SERVER_ERROR", arguments: code)
        }
        return localizedString(for: "AUTH_ERROR_SERVER_ERROR")
    }
    
    static var unknownError: String {
        return localizedString(for: "AUTH_ERROR_UNKNOWN")
    }
    
    static var logoutFailed: String {
        return localizedString(for: "AUTH_ERROR_LOGOUT_FAILED")
    }
    
    static var loginFailed: String {
        return localizedString(for: "AUTH_ERROR_LOGIN_FAILED")
    }

    static let newsReactionSentSuccessfully = "NEWS_REACTION_SENT_SUCCESSFULLY".localized
    static let newsCommentSentSuccessfully = "NEWS_COMMENT_SENT_SUCCESSFULLY".localized
} 