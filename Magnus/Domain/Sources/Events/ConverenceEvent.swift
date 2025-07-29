import Foundation

public struct ConferenceEvent {
    public let id: String
    public let title: String
    public let dateFrom: String
    public let dateTo: String
    public let location: String
    public let description: String
    public let image: String
    public let totalSeats: Int
    public let occupiedSeats: Int
    public let unconfirmedSeats: Int
    public let isOnline: Bool
    public let streamUrl: String?

    public init(id: String, title: String, dateFrom: String, dateTo: String, location: String, description: String, image: String, totalSeats: Int, occupiedSeats: Int, unconfirmedSeats: Int, isOnline: Bool, streamUrl: String? = nil) {
        self.id = id
        self.title = title
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.location = location
        self.description = description
        self.image = image
        self.totalSeats = totalSeats
        self.occupiedSeats = occupiedSeats
        self.unconfirmedSeats = unconfirmedSeats
        self.isOnline = isOnline
        self.streamUrl = streamUrl
    }

    public var IsOnline: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let startDate = formatter.date(from: dateFrom),
              let endDate = formatter.date(from: dateTo)
        else {
            return false
        }

        let currentDate = Date()
        return currentDate >= startDate && currentDate <= endDate
    }

    public var isFinished: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let startDate = formatter.date(from: dateFrom),
              let endDate = formatter.date(from: dateTo)
        else {
            return false
        }

        let currentDate = Date()
        return currentDate > endDate
    }
}
