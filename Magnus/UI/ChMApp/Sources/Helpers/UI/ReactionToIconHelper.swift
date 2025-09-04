import MagnusDomain

class ReactionToIconHelper {
    static func getIcon(from reaction: ReactionEnum) -> FontAwesome.Icon {
        switch reaction {
        case .THUMBS_UP:
            return .thumbsUp
        case .HEART:
            return .heart
        case .CLAPPING_HANDS:
            return .clappingHands
        case .LIGHT_BULB:
            return .lightBulb
        case .HAND_HOLDING_HEART:
            return .handHoldingHeart
        case .THUMBS_DOWN:
            return .thumbsDown
        case .SMILE:
            return .smile
        }
    }
}