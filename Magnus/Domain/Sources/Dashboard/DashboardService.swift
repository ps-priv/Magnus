


public struct DashboardResponse {
    public let news: [NewsItem]
    public let events: [EventItem]
    public let materials: [MaterialItem]

    public init(news: [NewsItem], events: [EventItem], materials: [MaterialItem]) {
        self.news = news
        self.events = events
        self.materials = materials
    }
}

public struct NewsItem :Identifiable, Hashable {
    public let id: String
    public let title: String
    public let publish_date: String
    public let image: String

    public init(id: String, title: String, publish_date: String, image: String) {
        self.id = id
        self.title = title
        self.publish_date = publish_date
        self.image = image
    }
}

public struct EventItem {
    public let id: String
    public let title: String
    public let date_from: String
    public let date_to: String
    public let url: String

    public init(id: String, title: String, date_from: String, date_to: String, url: String) {
        self.id = id
        self.title = title
        self.date_from = date_from
        self.date_to = date_to
        self.url = url
    }
}

public struct MaterialItem {
    public let id: String
    public let title: String
    public let event_title: String?
    public let type: MaterialTypeEnum
    public let url: String?
    public let date: String

    public init(id: String, title: String, event_title: String?, type: MaterialTypeEnum, url: String?, date: String) {
        self.id = id
        self.title = title
        self.event_title = event_title
        self.type = type
        self.url = url
        self.date = date
    }
}

public protocol DashboardService {
    func getDashboard() async throws -> DashboardResponse
}
