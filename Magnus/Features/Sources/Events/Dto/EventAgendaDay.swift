public struct EventAgendaDay {
    public let index: Int
    public let date: String //yyyy-MM-dd
    public let dayCaption: String

    public init(index: Int, date: String, dayCaption: String) {
        self.index = index
        self.date = date
        self.dayCaption = dayCaption
    }
}