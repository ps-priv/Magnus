import SwiftUI

struct ReactionComponentView: View {

    public init() {
    }

    public var body: some View {
        VStack(spacing: 8) {
            // Thumbs Up
            Button(action: {
                print("Thumbs Up tapped")
            }) {
                FAIcon(
                    FontAwesome.Icon.thumbsUp,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskBlue
                )
            }

            // Heart
            Button(action: {
                print("Heart tapped")
            }) {
                FAIcon(
                    FontAwesome.Icon.heart,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskBlue
                )
            }

            // Clapping Hands
            Button(action: {
                print("Clapping tapped")
            }) {
                FAIcon(
                    FontAwesome.Icon.smile,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskBlue
                )
            }

            // Lightbulb
            Button(action: {
                print("Lightbulb tapped")
            }) {
                FAIcon(
                    FontAwesome.Icon.eye,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskBlue
                )
            }

            // Hand with Heart
            Button(action: {
                print("Hand with heart tapped")
            }) {
                FAIcon(
                    FontAwesome.Icon.heart,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskBlue
                )
            }

            // Thumbs Down
            Button(action: {
                print("Thumbs Down tapped")
            }) {
                FAIcon(
                    FontAwesome.Icon.thumbsDown,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskBlue
                )
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        //.offset(x: -20, y: -20) // Pozycjonowanie w prawym dolnym rogu
        .zIndex(1000)
        .transition(.opacity.combined(with: .scale))
    }
}
