import Foundation

public enum TimeHelper {
    public static func formatPublishDate(_ timeString: String, timeFormat: String = "HH:mm:ss") -> String {
        let components = timeString.split(separator: ":")
        guard components.count >= 2 else { return timeString }
        return "\(components[0]):\(components[1])"
    }

    public static func isNow(_ time_from: String, _ time_to: String, timeFormat: String = "HH:mm:ss") -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentComponents = calendar.dateComponents([.hour, .minute], from: now)
        
        let timeFromComponents = time_from.split(separator: ":")
        let timeToComponents = time_to.split(separator: ":")
        
        guard timeFromComponents.count >= 2,
              timeToComponents.count >= 2,
              let fromHour = Int(timeFromComponents[0]),
              let fromMinute = Int(timeFromComponents[1]),
              let toHour = Int(timeToComponents[0]),
              let toMinute = Int(timeToComponents[1]),
              let currentHour = currentComponents.hour,
              let currentMinute = currentComponents.minute else {
            return false
        }
        
        let currentMinutes = currentHour * 60 + currentMinute
        let fromMinutes = fromHour * 60 + fromMinute
        let toMinutes = toHour * 60 + toMinute
        
        return currentMinutes >= fromMinutes && currentMinutes <= toMinutes
    }
}