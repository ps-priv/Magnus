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
enum LocalizedStrings {
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
    static let close = "CLOSE".localized
    static let back = "BACK".localized

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

    // Dashboard
    static let dashboardNewsTitle = "DASHBOARD_NEWS_TITLE".localized
    static let dashboardEventsSectionLoadMore = "DASHBOARD_EVENTS_LOAD_MORE".localized
    static let dashboardEventsTitle = "DASHBOARD_EVENTS_TITLE".localized
    static let dashboardUpcomingEventsTitle = "DASHBOARD_UPCOMING_EVENTS_TITLE".localized
    static let dashboardMaterialsTitle = "DASHBOARD_MATERIALS_TITLE".localized
    static let dashboardAcademyTitle = "DASHBOARD_ACADEMY_TITLE".localized

    // Pages titles
    static let dashboardScreenTitle = "DASHBOARD_SCREEN_TITLE".localized
    static let eventsListScreenTitle = "EVENTS_LIST_SCREEN_TITLE".localized
    static let eventDetailsScreenTitle = "EVENT_DETAILS_SCREEN_TITLE".localized
    static let eventMaterialsScreenTitle = "EVENT_MATERIALS_SCREEN_TITLE".localized
    static let materialsListScreenTitle = "MATERIALS_LIST_SCREEN_TITLE".localized
    static let materialDetailsScreenTitle = "MATERIAL_DETAILS_SCREEN_TITLE".localized
    static let newsListScreenTitle = "NEWS_LIST_SCREEN_TITLE".localized
    static let newsDetailsScreenTitle = "NEWS_DETAILS_SCREEN_TITLE".localized
    static let newsCreateScreenTitle = "NEWS_CREATE_SCREEN_TITLE".localized
    static let newsBookmarksScreenTitle = "NEWS_BOOKMARKS_SCREEN_TITLE".localized
    static let newsDraftsScreenTitle = "NEWS_DRAFTS_SCREEN_TITLE".localized
    static let newsEditScreenTitle = "NEWS_EDIT_SCREEN_TITLE".localized
    static let newsEditDraftScreenTitle = "NEWS_EDIT_DRAFT_SCREEN_TITLE".localized
    static let newsGroupsScreenTitle = "NEWS_GROUPS_SCREEN_TITLE".localized
    
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
    static let buttonClose = "CLOSE".localized

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

    // Events list
    static let eventsListLinkToArchive = "EVENTS_LIST_LINK_TO_ARCHIVE".localized
    static let eventsListEmptyStateTitle = "EVENTS_LIST_EMPTY_STATE_TITLE".localized
    static let eventsListEmptyStateDescription = "EVENTS_LIST_EMPTY_STATE_DESCRIPTION".localized
    static let eventAvailableTransmission = "EVENT_AVAILABLE_TRANSMISSION".localized
    static let eventInProgress = "EVENT_IN_PROGRESS".localized
    static let eventSoon = "EVENT_SOON".localized
    static let eventFinished = "EVENT_FINISHED".localized
    static let eventSeats = "EVENT_SEATS".localized
    static let eventSeatsNotConfirmed = "EVENT_SEATS_NOT_CONFIRMED".localized
    static let dashboardUpcomingEventsEmpty  = "DASHBOARD_UPCOMING_EVENTS_EMPTY".localized

    // Eventy qr code
    static let eventQrCodeScanToRegister = "EVENT_QR_CODE_SCAN_TO_REGISTER".localized

    // Archived Events
    static let archivedEventEmptyListMessage = "ARCHIVED_EVENT_EMPTY_LIST_MESSAGE".localized
    static let finishedEvent = "FINISHED_EVENT".localized
    static let archivedEventTitle = "ARCHIVED_EVENT_TITLE".localized

    // Academy
    static let academyDoctor = "ACADEMY_DOCTOR".localized
    static let academyPatient = "ACADEMY_PATIENT".localized
    
    // Network Connection
    static let noInternetConnectionTitle = "NO_INTERNET_CONNECTION_TITLE".localized
    static let noInternetConnectionMessage = "NO_INTERNET_CONNECTION_MESSAGE".localized
    static let noInternetConnectionRetryButton = "NO_INTERNET_CONNECTION_RETRY_BUTTON".localized

    // News list
    static let newsListEditNews = "NEWS_LIST_EDIT_NEWS".localized
    static let newsListDeleteNews = "NEWS_LIST_DELETE_NEWS".localized
    static let newsDetailsCommentsTab = "NEWS_DETAILS_COMMENTS_TAB".localized
    static let newsDetailsReactionsTab = "NEWS_DETAILS_REACTIONS_TAB".localized
    static let newsDetailsReadsTab = "NEWS_DETAILS_READS_TAB".localized

    static let createCommentForNewsPlaceholder = "CREATE_COMMENT_FOR_NEWS".localized
    static let newsDetailsNotFoundTitle = "NEWS_DETAILS_NOT_FOUND_TITLE".localized
    static let newsDetailsNotFoundMessage = "NEWS_DETAILS_NOT_FOUND_MESSAGE".localized

    static let newsReactionSentSuccessfully = "NEWS_REACTION_SENT_SUCCESSFULLY".localized

    //Event details
    static let eventTabEvent = "EVENT_DETAILS_EVENT".localized
    static let eventTabMaterials = "EVENT_DETAILS_MATERIALS".localized
    static let eventTabPhotobooth = "EVENT_DETAILS_PHOTOBOOTH".localized

    static let eventGifts: String = "EVENT_DETAILS_GIFTS".localized
    static let eventEventManager: String = "EVENT_DETAILS_EVENT_MANAGER".localized
    static let eventLocationContact: String = "EVENT_DETAILS_LOCATION_CONTACT".localized

    static let eventAgendaScreenTitle = "EVENT_AGENDA_SCREEN_TITLE".localized
    static let eventLocationScreenTitle = "EVENT_LOCATION_SCREEN_TITLE".localized
    static let eventDinnerScreenTitle = "EVENT_DINNER_SCREEN_TITLE".localized
    static let eventSurveyScreenTitle = "EVENT_SURVEY_SCREEN_TITLE".localized

    static let eventAgendaSpeaker = "EVENT_AGENDA_SPEAKER".localized
    static let eventAgendaPresenter = "EVENT_AGENDA_PRESENTER".localized
    static let eventAgendaJoinOnline = "EVENT_AGENDA_JOIN_ONLINE".localized
    static let eventAgendaQuiz = "EVENT_AGENDA_QUIZ".localized
    static let eventAgendaDay = "EVENT_AGENDA_DAY".localized

    static let eventDetailsNotFoundTitle = "EVENT_DETAILS_NOT_FOUND_TITLE".localized
    static let eventDetailsNotFoundMessage = "EVENT_DETAILS_NOT_FOUND_MESSAGE".localized

    //News groups
    static let newsGroupsCreateGroup = "NEWS_GROUPS_CREATE_GROUP".localized
    static let newsGroupsEmptyStateTitle = "NEWS_GROUPS_EMPTY_STATE_TITLE".localized
    static let newsGroupsEmptyStateDescription = "NEWS_GROUPS_EMPTY_STATE_DESCRIPTION".localized

    //News bookmarks
    static let newsBookmarksEmptyStateTitle = "NEWS_BOOKMARKS_EMPTY_STATE_TITLE".localized
    static let newsBookmarksEmptyStateDescription = "NEWS_BOOKMARKS_EMPTY_STATE_DESCRIPTION".localized

    static let newsEmptyStateTitle = "NEWS_EMPTY_STATE_TITLE".localized
    static let newsEmptyStateDescription = "NEWS_EMPTY_STATE_DESCRIPTION".localized

    static let publishButton = "PUBLISH_BUTTON".localized
    static let cancelButton = "CANCEL_BUTTON".localized
    static let saveButton = "SAVE_BUTTON".localized
    static let deleteButton = "DELETE_BUTTON".localized

    static let newsAddTitle = "NEWS_ADD_TITLE".localized
    static let newsAddAttachments = "NEWS_ADD_ATTACHMENTS".localized
    static let attachmentFromDevice = "ATTACHMENT_FROM_DEVICE".localized
    static let attachmentFromLink = "ATTACHMENT_FROM_LINK".localized
    static let newsAddContent = "NEWS_ADD_CONTENT".localized
    static let newsAddTags = "NEWS_ADD_TAGS".localized
    static let newsAddTagsButton = "NEWS_ADD_TAGS_BUTTON".localized

    static let audienceSettingsAll = "AUDIENCE_SETTINGS_ALL".localized
    static let audienceSettingsSelected = "AUDIENCE_SETTINGS_SELECTED".localized

    static let attachmentAdd    = "ATTACHMENT_ADD".localized
    static let attachmentTitle    = "ATTACHMENT_TITLE".localized
    static let attachmentTitlePlaceholder = "ATTACHMENT_TITLE_PLACEHOLDER".localized
    static let attachmentFileName = "ATTACHMENT_FILE_NAME".localized
    static let attachmentFileNameNoFileSelected = "ATTACHMENT_FILE_NAME_NO_FILE_SELECTED".localized
    static let attachmentFileType = "ATTACHMENT_FILE_TYPE".localized
    static let attachmentFilePickerButton = "ATTACHMENT_FILE_PICKER_BUTTON".localized
    static let attachmentFilePickerTitle = "ATTACHMENT_FILE_PICKER_TITLE".localized
    static let attachmentFilePickerCancel = "ATTACHMENT_FILE_PICKER_CANCEL".localized

    static let attachmentLink = "ATTACHMENT_LINK".localized
    static let attachmentLinkPlaceholder = "ATTACHMENT_LINK_PLACEHOLDER".localized

    static let newsAddSuccessMessage = "NEWS_ADD_SUCCESS_MESSAGE".localized
    static let newsAddErrorMessage = "NEWS_ADD_ERROR_MESSAGE".localized
    static let newsAddSaveToStorage = "NEWS_ADD_SAVE_TO_STORAGE".localized

    static let eventPhotoScreenTitle = "EVENT_PHOTO_SCREEN_TITLE".localized
    static let eventGalleryScreenTitle = "EVENT_GALLERY_SCREEN_TITLE".localized
    static let eventAddPhotoScreenTitle = "EVENT_ADD_PHOTO_SCREEN_TITLE".localized

    static let eventPhotosNotFoundTitle = "EVENT_PHOTOS_NOT_FOUND_TITLE".localized
    static let eventPhotosNotFoundMessage = "EVENT_PHOTOS_NOT_FOUND_MESSAGE".localized

    static let endEditingButton = "END_EDITING_BUTTON".localized
}