public struct ConferenceEventMaterial : Identifiable, Hashable, Decodable {
    public let id: String
    public let name: String
    public let file_type: Int
    public let link: String
    public let publication_date: String //yyyy-MM-dd HH:mm:ss

    public init(
        id: String, name: String, file_type: Int, link: String, publication_date: String
    ) {
        self.id = id
        self.name = name
        self.file_type = file_type
        self.link = link
        self.publication_date = publication_date
    }
}