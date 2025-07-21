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
    
    // Forgot Password View
    static let forgotPasswordTitle = "FORGOT_PASSWORD_TITLE".localized
    static let forgotPasswordMessage = "FORGOT_PASSWORD_MESSAGE".localized
    static let resetPasswordButton = "RESET_PASSWORD_BUTTON".localized
    static let haveVerificationCode = "HAVE_VERIFICATION_CODE".localized
    
    // Password Reset Confirmation
    static let emailSentMessage = "EMAIL_SENT_MESSAGE".localized
    static let goToPasswordReset = "GO_TO_PASSWORD_RESET".localized
    
    // Password Change Confirmation
    static let passwordChangedMessage = "PASSWORD_CHANGED_MESSAGE".localized
    static let goToLogin = "GO_TO_LOGIN".localized
    
    // Common
    static let loading = "LOADING".localized
    static let error = "ERROR".localized
    static let ok = "OK".localized
    static let cancel = "CANCEL".localized
    static let load_more = "LOAD_MORE".localized
    
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
    
    //Dashboard
    static let dashboardNewsTitle = "DASHBOARD_NEWS_TITLE".localized
    static let dashboardEventsSectionLoadMore = "DASHBOARD_EVENTS_LOAD_MORE".localized
    static let dashboardEventsTitle = "DASHBOARD_EVENTS_TITLE".localized
    static let dashboardUpcomingEventsTitle = "DASHBOARD_UPCOMING_EVENTS_TITLE".localized
    
    //Pages titles
    static let dashboardScreenTitle = "DASHBOARD_SCREEN_TITLE".localized
    static let eventsListScreenTitle = "EVENTS_LIST_SCREEN_TITLE".localized
    static let eventDetailsScreenTitle = "EVENT_DETAILS_SCREEN_TITLE".localized
    static let materialsListScreenTitle = "MATERIALS_LIST_SCREEN_TITLE".localized
    static let materialDetailsScreenTitle = "MATERIAL_DETAILS_SCREEN_TITLE".localized
    static let newsListScreenTitle = "NEWS_LIST_SCREEN_TITLE".localized
    static let newsDetailsScreenTitle = "NEWS_DETAILS_SCREEN_TITLE".localized
    static let userProfileScreenTitle = "USER_PROFILE_SCREEN_TITLE".localized
    static let settingsScreenTitle = "SETTINGS_SCREEN_TITLE".localized
    static let academyScreenTitle = "ACADEMY_SCREEN_TITLE".localized
    static let messagesListScreenTitle = "MESSAGES_SCREEN_TITLE".localized
    static let messageDetailsScreenTitle = "MESSAGE_DETAILS_SCREEN_TITLE".localized

    // User profile
    static let userProfileInformationButton = "USER_PROFILE_INFORMATION_BUTTON".localized
    static let userProfileIdButton = "USER_PROFILE_ID_BUTTON".localized
    static let userProfileChangePassword = "USER_PROFILE_CHANGE_PASSWORD".localized

    // User profile
    static let userProfileFirstname = "USER_PROFILE_FIRSTNAME".localized
    static let userProfileLastname = "USER_PROFILE_LASTNAME".localized
    static let userProfileDepartment = "USER_PROFILE_DEPARTMENT".localized
    static let userProfileEmail = "USER_PROFILE_EMAIL".localized
    static let userProfileNpwz = "USER_PROFILE_NPWZ".localized
    static let userProfileAddress = "USER_PROFILE_ADDRESS".localized
    static let userProfilePostalcode = "USER_PROFILE_POSTALCODE".localized
    static let userProfileCity = "USER_PROFILE_CITY".localized
    static let userProfilePesel = "USER_PROFILE_PESEL".localized
    static let userProfileHasCompany = "USER_PROFILE_HAS_COMPANY".localized
    static let userProfileNip = "USER_PROFILE_NIP".localized
    static let userProfileCompanyName = "USER_PROFILE_COMPANY_NAME".localized
    static let userProfileTaxOffice = "USER_PROFILE_TAX_OFFICE".localized
    static let userProfilePolicy = "USER_PROFILE_POLICY".localized
    static let userProfilePolicyLink = "USER_PROFILE_POLICY_LINK".localized
    static let userProfileRodo = "USER_PROFILE_RODO".localized
    static let userProfileRodoLink = "USER_PROFILE_RODO_LINK".localized
    static let userProfileMarketing = "USER_PROFILE_MARKETING".localized
    static let userProfileMarketingLink = "USER_PROFILE_MARKETING_LINK".localized

    static let userProfileQrcodeId = "USER_PROFILE_QRCODE_ID".localized
    static let userProfileQrcodeDescription = "USER_PROFILE_QRCODE_DESCRIPTION".localized

    static let userProfileNewPassword = "USER_PROFILE_NEW_PASSWORD".localized
    static let userProfileRetypeNewPassword = "USER_PROFILE_RETYPE_NEW_PASSWORD".localized

    // Buttons
    static let buttonSave = "BUTTON_SAVE".localized
    static let buttonLogout = "BUTTON_LOGOUT".localized
    static let buttonChangePassword = "BUTTON_CHANGE_PASSWORD".localized

    // Months
    static let MONTH_1 = "MONTH_1".localized
    static let MONTH_2 = "MONTH_2".localized
    static let MONTH_3 = "MONTH_3".localized
    static let MONTH_4 = "MONTH_4".localized
    static let MONTH_5 = "MONTH_5".localized
    static let MONTH_6 = "MONTH_6".localized
    static let MONTH_7 = "MONTH_7".localized
    static let MONTH_8 = "MONTH_8".localized
    static let MONTH_9 = "MONTH_9".localized
    static let MONTH_10 = "MONTH_10".localized
    static let MONTH_11 = "MONTH_11".localized
    static let MONTH_12 = "MONTH_12".localized
    static let months = ["", MONTH_1, MONTH_2, MONTH_3, MONTH_4, MONTH_5, MONTH_6, MONTH_7, MONTH_8, MONTH_9, MONTH_10, MONTH_11, MONTH_12]


}
