public enum MagnusStorageKey: String, CaseIterable {
    case eventDetails = "magnus_event_details"
    case addNews = "magnus_add_news"
    
    public var keychain: String {
        return "pl.mz.magnus.\(self.rawValue)"
    }
}