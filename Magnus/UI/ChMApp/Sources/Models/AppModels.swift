import Foundation
import MagnusDomain
import MagnusApplication

// MARK: - Event Model
struct Event: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    let location: String
    let imageUrl: String?
    let isRegistered: Bool
    let maxParticipants: Int?
    let currentParticipants: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startDate)
    }
    
    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let startString = formatter.string(from: startDate)
        let endString = formatter.string(from: endDate)
        
        return "\(startString) - \(endString)"
    }
}

// MARK: - Material Model
struct Material: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let type: MaterialType
    let fileUrl: String?
    let thumbnailUrl: String?
    let fileSize: String?
    let downloadCount: Int
    let publishDate: Date
    let tags: [String]
    
    var formattedPublishDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: publishDate)
    }
}

enum MaterialType: String, CaseIterable, Codable {
    case pdf = "pdf"
    case video = "video"
    case presentation = "presentation"
    case document = "document"
    case image = "image"
    
    var displayName: String {
        switch self {
        case .pdf:
            return "PDF"
        case .video:
            return "Video"
        case .presentation:
            return "Prezentacja"
        case .document:
            return "Dokument"
        case .image:
            return "Obraz"
        }
    }
    
    var icon: FontAwesome.Icon {
        switch self {
        case .pdf:
            return .bell
        case .video:
            return .bell
        case .presentation:
            return .bell
        case .document:
            return .bell
        case .image:
            return .bell
        }
    }
}

// MARK: - News Model (extending existing NewsItem)
extension NewsItem {
    var formattedPublishDate: String {
        return PublishedDateHelper.formatPublishDate(publish_date)
    }
} 
