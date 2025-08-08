import MagnusDomain


public struct SendReactionRequest: Encodable {
    let reaction_type: ReactionEnum

    enum CodingKeys: String, CodingKey {
        case reaction_type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(reaction_type.rawValue, forKey: .reaction_type)
    }
}