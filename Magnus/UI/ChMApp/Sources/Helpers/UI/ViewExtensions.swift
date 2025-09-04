import SwiftUI

// MARK: - View Extensions
extension View {
    /// Zaokrągla wybrane rogi
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Custom Shape for Specific Corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Alternative with SwiftUI Style
extension View {
    /// Nowoczesny sposób z SwiftUI
    func roundedCorners(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(
            .rect(
                topLeadingRadius: corners.contains(.topLeft) ? radius : 0,
                bottomLeadingRadius: corners.contains(.bottomLeft) ? radius : 0,
                bottomTrailingRadius: corners.contains(.bottomRight) ? radius : 0,
                topTrailingRadius: corners.contains(.topRight) ? radius : 0
            )
        )
    }
}

// MARK: - Modern Corner Set
struct RectCorner: OptionSet {
    let rawValue: Int
    
    static let topLeft = RectCorner(rawValue: 1 << 0)
    static let topRight = RectCorner(rawValue: 1 << 1)
    static let bottomLeft = RectCorner(rawValue: 1 << 2)
    static let bottomRight = RectCorner(rawValue: 1 << 3)
    
    static let all: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    static let top: RectCorner = [.topLeft, .topRight]
    static let bottom: RectCorner = [.bottomLeft, .bottomRight]
    static let left: RectCorner = [.topLeft, .bottomLeft]
    static let right: RectCorner = [.topRight, .bottomRight]
} 