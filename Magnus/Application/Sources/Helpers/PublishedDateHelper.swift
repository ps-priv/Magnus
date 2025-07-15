

import Foundation

// MARK: - Email Validation Helper

public struct PublishedDateHelper {
    public static  func formatPublishDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 dzień temu" : "\(days) dni temu"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 godzinę temu" : "\(hours) godzin temu"
        } else {
            return "Teraz"
        }
    }
}
