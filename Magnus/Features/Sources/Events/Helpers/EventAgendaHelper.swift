import MagnusDomain
import MagnusApplication

public class EventAgendaHelper {
    
    public static func getEventDays(agenda: [ConferenceEventAgenda]) -> [EventAgendaDay] {

        if (agenda.isEmpty) {
            return []
        }

        var days: [EventAgendaDay] = []
        var currentDate: String = ""
        var currentDayIndex: Int = 0

        for agendaItem in agenda {
            let date = PublishedDateHelper.formatPublishDate(agendaItem.date, dateFormat: "yyyy-MM-dd") 
            let dateCaption = FeaturesLocalizedStrings.eventAgendaDay 

            days.append(EventAgendaDay(index: currentDayIndex, date: date, dayCaption: dateCaption))

            currentDayIndex += 1
        }

        return days
    }
}
