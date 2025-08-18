public enum MagnusStorageKey: String, CaseIterable {
    case eventDetails = "magnus_event_details"
    public var keychain: String {
        return "pl.mz.magnus.\(self.rawValue)"
    }
}