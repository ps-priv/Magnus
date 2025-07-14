import Foundation

public enum MaterialTypeEnum: Int, CaseIterable, Codable {
    case generalMaterial = 1
    case eventMaterial = 2
    
    public var displayName: String {
        switch self {
        case .generalMaterial:
            return "Materiały ogólne"
        case .eventMaterial:
            return "Materiały z wydarzeń"
        }
    }
    
    // public var iconName: String {
    //     switch self {
    //     case .generalMaterial:
    //         return "doc.text"
    //     case .eventMaterial:
    //         return "calendar.badge.clock"
    // }
}