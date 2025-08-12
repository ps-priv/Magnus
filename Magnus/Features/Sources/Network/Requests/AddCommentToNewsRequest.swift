

public struct AddCommentToNewsRequest: Encodable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }

    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<AddCommentToNewsRequest.CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
    }
}