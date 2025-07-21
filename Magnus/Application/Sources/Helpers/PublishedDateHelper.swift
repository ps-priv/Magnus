

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

    public static func formatDateRangeForEvent(_ from: String, _ to: String, _ months: [String]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "pl_PL")
        
        guard let fromDate = formatter.date(from: from), let toDate = formatter.date(from: to) else {
            return "\(from) - \(to)"
        }
        
        let calendar = Calendar.current
        let fromDay = calendar.component(.day, from: fromDate)
        let toDay = calendar.component(.day, from: toDate)
        let fromMonth = calendar.component(.month, from: fromDate)
        let toMonth = calendar.component(.month, from: toDate)
        let fromYear = calendar.component(.year, from: fromDate)
        let toYear = calendar.component(.year, from: toDate)
        
        // let months = [
        //     "", "stycznia", "lutego", "marca", "kwietnia", "maja", "czerwca",
        //     "lipca", "sierpnia", "września", "października", "listopada", "grudnia"
        // ]
        
        //let month = LocalizedStrings.months[fromMonth]

        if fromYear == toYear && fromMonth == toMonth && fromDay == toDay {
            // Przykład: 11 maja 2025
            return "\(fromDay) \(months[fromMonth]) \(fromYear)"
        } else if fromYear == toYear {
            if fromMonth == toMonth {
                // Przykład: 11 - 14 maja 2025
                return "\(fromDay) - \(toDay) \(months[toMonth]) \(toYear)"
            } else {
                // Przykład: 28 kwietnia - 2 maja 2025
                return "\(fromDay) \(months[fromMonth]) - \(toDay) \(months[toMonth]) \(toYear)"
            }
        } else {
            // Przykład: 28 grudnia 2024 - 2 stycznia 2025
            return "\(fromDay) \(months[fromMonth]) \(fromYear) - \(toDay) \(months[toMonth]) \(toYear)"
        }
    }
}
