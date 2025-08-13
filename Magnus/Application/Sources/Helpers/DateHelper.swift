
import Foundation

public struct DateHelper {
    public static func getDateStatus(from dateFrom: String, to dateTo: String) -> DateStatus {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            guard let startDate = formatter.date(from: dateFrom),
                let endDate = formatter.date(from: dateTo) else {
            return .unknown
        }
        
        let currentDate = Date()
        
        if currentDate < startDate {
            return .future
        } else if currentDate > endDate {
            return .past
        } else {
            return .between
        }
    }

    public enum DateStatus {
        case future
        case past
        case between
        case unknown
    }

    public static func isEventFinished(from dateFrom: String, to dateTo: String) -> Bool {
        let result = getDateStatus(from: dateFrom, to: dateTo)
        return result == .past
    }

    public static func isEventUpcoming(from dateFrom: String, to dateTo: String) -> Bool {
        let result = getDateStatus(from: dateFrom, to: dateTo)
        return result == .future
    }

    public static func isEventOngoing(from dateFrom: String, to dateTo: String) -> Bool {
        let result = getDateStatus(from: dateFrom, to: dateTo)
        return result == .between
    }
}
    
