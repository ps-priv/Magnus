public struct ConferenceEventDetails : Hashable, Decodable {
    public let title: String
    public let date_from: String //yyyy-MM-dd
    public let date_to: String //yyyy-MM-dd
    public let image: String
    public let name: String
    public let description: String
    public let location: ConferenceEventLocation
    public let guardians: [ConferenceEventGuardians]
    public let agenda: [ConferenceEventAgenda]
    public let dinner: ConferenceEventDinner
    public let materials: [ConferenceEventMaterial]
    public let photo_booth: [ConferenceEventPhotoBooth]

    public init(
        title: String,
        date_from: String,
        date_to: String,
        image: String,
        name: String,
        description: String,
        location: ConferenceEventLocation,
        guardians: [ConferenceEventGuardians],
        agenda: [ConferenceEventAgenda],
        dinner: ConferenceEventDinner,
        materials: [ConferenceEventMaterial],
        photo_booth: [ConferenceEventPhotoBooth]
    ) {
        self.title = title
        self.date_from = date_from
        self.date_to = date_to
        self.image = image
        self.name = name
        self.description = description
        self.location = location
        self.guardians = guardians
        self.agenda = agenda
        self.dinner = dinner
        self.materials = materials
        self.photo_booth = photo_booth
    }

    public var mainInfo: ConferenceEventMainInfo {
        return ConferenceEventMainInfo(
            title: title,
            date_from: date_from,
            date_to: date_to,
            image: image,
            name: name,
            description: description
        )
    }
}

public struct ConferenceEventMainInfo {
    public let title: String
    public let date_from: String //yyyy-MM-dd
    public let date_to: String //yyyy-MM-dd
    public let image: String
    public let name: String
    public let description: String

    public init(
        title: String,
        date_from: String,
        date_to: String,
        image: String,
        name: String,
        description: String
    ) {
        self.title = title
        self.date_from = date_from
        self.date_to = date_to
        self.image = image
        self.name = name
        self.description = description
    }
}

    