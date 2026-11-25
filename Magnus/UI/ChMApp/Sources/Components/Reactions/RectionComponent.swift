import SwiftUI
import MagnusDomain


struct RectionComponent: View {

    let reactionsCount: Int
    let selectedReaction: ReactionEnum

    init(
        reactionsCount: Int,
        selectedReaction: ReactionEnum = .SMILE
    ) {
        self.reactionsCount = reactionsCount
        self.selectedReaction = selectedReaction
    }

    var body: some View {
            HStack(spacing: 2) {
                FAIcon(
                    getIcon(for: selectedReaction),
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskTextGrey
                )
                Text(String(reactionsCount))
                    .font(.novoNordiskSmallText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
    }

    private func getIcon(for reaction: ReactionEnum) -> FontAwesome.Icon {
        switch reaction {
            case .THUMBS_UP: return FontAwesome.Icon.thumbsUp
            case .HEART: return FontAwesome.Icon.heart
            case .CLAPPING_HANDS: return FontAwesome.Icon.clappingHands
            case .LIGHT_BULB: return FontAwesome.Icon.lightBulb
            case .HAND_HOLDING_HEART: return FontAwesome.Icon.handHoldingHeart
            case .THUMBS_DOWN: return FontAwesome.Icon.thumbsDown
            case .SMILE: return FontAwesome.Icon.smile
        }
    }
}
