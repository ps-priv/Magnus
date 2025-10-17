import Foundation
import MagnusDomain

public class EventAgendaMock {

    public static func getEventAgendaContent(hasQuiz: Bool = true, hasOnline: Bool = true, timeFrom: String = "10:00:00", timeTo: String = "10:45:00") -> ConferenceEventAgendaContent {
        let eventAgenda = ConferenceEventAgendaContent(
            id: "1",
            time_from: timeFrom,
            time_to: timeTo,
            place: "Sala niebieska",
            title: "Rozpoczęcie",
            speakers: "Andrzej Borek",
            presenters: "Jan Kowalski",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            is_quiz: hasQuiz ? 1 : 0,
            is_online: hasOnline ? 1 : 0
        )
        return eventAgenda
    }
}
