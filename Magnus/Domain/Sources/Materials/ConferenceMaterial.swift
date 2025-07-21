import Foundation

public struct ConferenceMaterial: Codable {
    public let id: String
    public let title: String
    public let type: ConferenceMaterialType
    public let publicationDate: String
    public let eventId: String?
    public let eventName: String?

    public init(
        id: String,
        title: String,
        type: ConferenceMaterialType,
        publicationDate: String,
        eventId: String? = nil,
        eventName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.publicationDate = publicationDate
        self.eventId = eventId
        self.eventName = eventName
    }
}

public enum ConferenceMaterialType: String, Codable, CaseIterable {
    case pdf
    case docx
    case link
}
