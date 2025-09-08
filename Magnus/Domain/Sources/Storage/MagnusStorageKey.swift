public enum MagnusStorageKey: String, CaseIterable {
    case eventDetails = "magnus_event_details"
    case addNews = "magnus_add_news"
    case agendaItem = "magnus_agenda_item"
    case location = "magnus_location"
    
    public var keychain: String {
        return "pl.mz.magnus.\(self.rawValue)"
    }
}