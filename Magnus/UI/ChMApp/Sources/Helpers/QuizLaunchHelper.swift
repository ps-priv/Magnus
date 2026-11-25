import Foundation

public class QuizLaunchHelper {
    public static func enableQuizLaunch(is_quiz: Int, agendaDate: String, timeFrom: String, timeTo: String) -> Bool {

        let allowedFunctions = AllowedFunctions()

        if !allowedFunctions.allowQuiz {
            return false
        }

        if is_quiz == 0 {
            return false
        }

        if is_quiz == 1 {
            return true
        }
        
        // Check if agenda date matches current date
        if !isCurrentDate(agendaDate: agendaDate) {
            return false
        }

        return isBetween(timeFrom: timeFrom, timeTo: timeTo)
    }
    
    /// Checks if the agenda date matches the current date
    /// - Parameter agendaDate: Date in format "yyyy-MM-dd"
    /// - Returns: True if agendaDate matches current date, false otherwise
    public static func isCurrentDate(agendaDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let now = Date()
        let currentDateString = dateFormatter.string(from: now)
        
        return agendaDate == currentDateString
    }
    
    /// Checks if the current time is between timeFrom and timeTo
    /// - Parameters:
    ///   - timeFrom: Start time in format "HH:mm:ss"
    ///   - timeTo: End time in format "HH:mm:ss"
    /// - Returns: True if current time is between timeFrom and timeTo, false otherwise
    public static func isBetween(timeFrom: String, timeTo: String) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentComponents = calendar.dateComponents([.hour, .minute, .second], from: now)
        
        let timeFromComponents = timeFrom.split(separator: ":")
        let timeToComponents = timeTo.split(separator: ":")
        
        guard timeFromComponents.count >= 3,
              timeToComponents.count >= 3,
              let fromHour = Int(timeFromComponents[0]),
              let fromMinute = Int(timeFromComponents[1]),
              let fromSecond = Int(timeFromComponents[2]),
              let toHour = Int(timeToComponents[0]),
              let toMinute = Int(timeToComponents[1]),
              let toSecond = Int(timeToComponents[2]),
              let currentHour = currentComponents.hour,
              let currentMinute = currentComponents.minute,
              let currentSecond = currentComponents.second else {
            return false
        }
        
        let currentSeconds = currentHour * 3600 + currentMinute * 60 + currentSecond
        let fromSeconds = fromHour * 3600 + fromMinute * 60 + fromSecond
        let toSeconds = toHour * 3600 + toMinute * 60 + toSecond
        
        return currentSeconds >= fromSeconds && currentSeconds <= toSeconds
    }
}