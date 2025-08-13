import Foundation

public struct ConferenceEvent: Decodable {
    public let id: String
    public let name: String
    public let description: String
    public let date_from: String
    public let date_to: String
    public let image: String
    public let seats: Seats

    public init(
        id: String, name: String, description: String, date_from: String, date_to: String, image: String, seats: Seats) {
        self.id = id
        self.name = name
        self.description = description
        self.date_from = date_from
        self.date_to = date_to
        self.image = image
        self.seats = seats
    }


    public var IsOnline: Bool {
        // let formatter = DateFormatter()
        // formatter.dateFormat = "yyyy-MM-dd HH:mm"

        // guard let startDate = formatter.date(from: date_from),
        //     let endDate = formatter.date(from: date_to)
        // else {
        //     return false
        // }

        // let currentDate = Date()
        // return currentDate >= startDate && currentDate <= endDate

        return false
    }

    public var isFinished: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let endDate = formatter.date(from: date_to)
        else {
            return false
        }

        let currentDate = Date()
        return currentDate > endDate
    }
}
