public struct DashboardResponse: Decodable {
    public let news: [NewsItem]
    public let events: [EventItem]
    public let materials: [MaterialItem]
    public let academy: [AcademyItem]

    public init(
        news: [NewsItem], events: [EventItem], materials: [MaterialItem], academy: [AcademyItem]
    ) {
        self.news = news
        self.events = events
        self.materials = materials
        self.academy = academy
    }
}

public struct NewsItem: Identifiable, Hashable, Decodable {
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

public struct EventItem: Identifiable, Hashable, Decodable {
    public let id: String
    public let name: String
    public let date_from: String
    public let date_to: String
    public let image: String

    public init(id: String, name: String, date_from: String, date_to: String, image: String) {
        self.id = id
        self.name = name
        self.date_from = date_from
        self.date_to = date_to
        self.image = image
    }
}

public enum FileTypeEnum: Int, CaseIterable, Codable {
    case pdf = 1
    case docx = 2
    case sharepoint = 3
    case link = 4
}

public struct MaterialItem: Identifiable, Hashable, Decodable {
    public let id: String
    public let name: String
    public let event_title: String?
    public let type: MaterialTypeEnum
    public let file_type: FileTypeEnum
    public let link: String?
    public let publication_date: String

    public init(
        id: String, name: String, event_title: String?, type: MaterialTypeEnum, file_type: FileTypeEnum, link: String?,
        publication_date: String
    ) {
        self.id = id
        self.name = name
        self.event_title = event_title
        self.type = type
        self.file_type = file_type
        self.link = link
        self.publication_date = publication_date
    }
}

public struct AcademyItem: Identifiable, Hashable, Decodable {
    public let id: String
    public let name: String
    public let event_title: String?
    public let file_type: MaterialTypeEnum
    public let link: String?
    public let publication_date: String

    public init(
        id: String, name: String, event_title: String?, file_type: MaterialTypeEnum, link: String?,
        publication_date: String
    ) {
        self.id = id
        self.name = name
        self.event_title = event_title
        self.file_type = file_type
        self.link = link
        self.publication_date = publication_date
    }
}

public protocol DashboardService {
    func getDashboard() async throws -> DashboardResponse
}
