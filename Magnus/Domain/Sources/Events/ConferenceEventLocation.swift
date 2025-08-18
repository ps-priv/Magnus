import Foundation

public struct ConferenceEventLocation : Hashable, Decodable, Encodable {
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

    public func getLocationAddress() -> String {
        return "\(city) | \(street)"
    }

    public func getFullAddress() -> String {
        return "\(street) \(city)"
    }

    public func getDomainAddressFromWww() -> String {
        let urlString = www.hasPrefix("http") ? www : "https://\(www)"
        guard let url = URL(string: urlString),
              let host = url.host else {
            return www
        }
        return host
        //return host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
    }
}