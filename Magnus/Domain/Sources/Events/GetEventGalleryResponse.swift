import Foundation

public struct GetEventGalleryResponse: Decodable {
    public let photo_booth: [ConferenceEventPhotoBooth]

    public init(photo_booth: [ConferenceEventPhotoBooth]) {
        self.photo_booth = photo_booth
    }
}