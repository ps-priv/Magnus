public struct ConferenceEventDinner : Hashable, Decodable {
    public let name: String
    public let city: String
    public let zip_code: String
    public let street: String
    public let latitude: String
    public let longitude: String
    public let image: String
    public let phone: String
    public let email: String
    public let www: String
    public let header_description: String
    public let description: String

    public init(
        name: String, city: String, zip_code: String, street: String, latitude: String, longitude: String, image: String,
        phone: String, email: String, www: String, header_description: String, description: String
    ) {
        self.name = name
        self.city = city
        self.zip_code = zip_code
        self.street = street
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
        self.phone = phone
        self.email = email
        self.www = www
        self.header_description = header_description
        self.description = description
    }
}