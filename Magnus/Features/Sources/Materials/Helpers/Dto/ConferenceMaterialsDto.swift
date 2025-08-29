import Foundation
import MagnusDomain

public struct ConferenceMaterialsDto {
    public let event_title: String
    public let date_from: String
    public let date_to: String

    public let eventMaterials: [ConferenceMaterialListItem]

    init(event_title: String, date_from: String, date_to: String, eventMaterials: [ConferenceMaterialListItem]) {
        self.event_title = event_title
        self.date_from = date_from
        self.date_to = date_to
        self.eventMaterials = eventMaterials
    }

    public func hasMaterials() -> Bool {
        return !eventMaterials.isEmpty
    }
}