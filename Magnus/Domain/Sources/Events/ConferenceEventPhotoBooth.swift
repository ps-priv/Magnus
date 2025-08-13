
public struct ConferenceEventPhotoBooth : Identifiable, Hashable, Decodable {
    public let id: String
    public let image: String //url

    public init(id: String, image: String) {
        self.id = id
        self.image = image
    }
}