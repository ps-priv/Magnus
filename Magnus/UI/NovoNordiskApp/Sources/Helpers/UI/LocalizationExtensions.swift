import Foundation

extension String {
    /// Returns localized string from Localizable.strings
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns localized string with formatted arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

// Helper struct for common localized strings
struct LocalizedStrings {
    // Login View
    static let loginTitle = "LOGIN_TITLE".localized
    static let emailLabel = "EMAIL_LABEL".localized
    static let emailPlaceholder = "EMAIL_PLACEHOLDER".localized
    static let passwordLabel = "PASSWORD_LABEL".localized
    static let passwordPlaceholder = "PASSWORD_PLACEHOLDER".localized
    static let forgotPassword = "FORGOT_PASSWORD".localized
    static let loginButton = "LOGIN_BUTTON".localized
    static let registerButton = "REGISTER_BUTTON".localized
    static let loginError = "LOGIN_ERROR".localized
    
    // Common
    static let loading = "LOADING".localized
    static let error = "ERROR".localized
    static let ok = "OK".localized
    static let cancel = "CANCEL".localized
    
    // Validation
    static let fieldRequired = "FIELD_REQUIRED".localized
    static let invalidEmail = "INVALID_EMAIL".localized
    static let passwordTooShort = "PASSWORD_TOO_SHORT".localized
    
    // Main App
    static let appTitle = "APP_TITLE".localized
    static let welcomeMessage = "WELCOME_MESSAGE".localized
    static let loginUserButton = "LOGIN_USER_BUTTON".localized
    
    // Tab Bar
    static let tabHome = "TAB_HOME".localized
    static let tabButtons = "TAB_BUTTONS".localized
    static let tabTextBoxes = "TAB_TEXT_BOXES".localized
    static let tabRadioButtons = "TAB_RADIO_BUTTONS".localized
} 