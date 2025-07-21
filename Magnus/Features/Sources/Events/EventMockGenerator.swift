import Foundation
import MagnusDomain

public class EventMockGenerator {
    private static let novoNordiskEventTitles = [
        "Konferencja Novo Nordisk 2025 - Przyszłość Diabetologii",
        "Warsztat: Nowoczesne technologie CGM w praktyce",
        "Webinar: Semaglutyd w leczeniu cukrzycy typu 2",
        "Sympozjum: Ozempic® - nowe możliwości terapeutyczne",
        "Szkolenie: Wegovy® w walce z otyłością",
        "Konferencja: Rybelsus® - pierwsza tabletka GLP-1",
        "Warsztat: Tresiba® FlexTouch® w codziennej praktyce",
        "Panel dyskusyjny: Insulina degludec w terapii",
        "Webinar: Profilaktyka powikłań cukrzycy",
        "Sympozjum: Edukacja pacjentów z cukrzycą",
        "Konferencja: Personalizacja terapii diabetologicznej",
        "Warsztat: Monitorowanie glukozy u pacjentów",
        "Webinar: Najnowsze wytyczne diabetologiczne 2025",
        "Panel: Lifestyle medicine w diabetologii",
        "Sympozjum: Technologie wspomagające leczenie",
        "Konferencja: Przełom w terapii GLP-1",
        "Warsztat: Praktyczne aspekty insulinoterapii",
        "Webinar: Diabetologia przyszłości - wizja 2030",
    ]

    private static let eventDescriptions = [
        "Główna konferencja poświęcona najnowszym osiągnięciom w diabetologii i endokrynologii. Spotka się z nami ponad 200 specjalistów z całego kraju.",
        "Praktyczne szkolenie z wykorzystania najnowszych technologii w leczeniu cukrzycy. Poznaj systemy CGM i pompy insulinowe nowej generacji.",
        "Online prezentacja najnowszych badań i terapii. Eksperci przedstawią najbardziej efektywne metody terapeutyczne.",
        "Interaktywne warsztaty z ekspertami Novo Nordisk. Praktyczne scenariusze kliniczne i case studies z prawdziwymi pacjentami.",
        "Sympozjum naukowe poświęcone najnowszym badaniom klinicznym i ich praktycznym zastosowaniom w codziennej praktyce lekarskiej.",
        "Szkolenie dla lekarzy pierwszego kontaktu z podstawami nowoczesnej diabetologii i najnowszymi standardami leczenia.",
        "Panel dyskusyjny z udziałem czołowych ekspertów diabetologów z Polski i Europy. Omówienie kontrowersyjnych tematów.",
        "Webinar edukacyjny dla pacjentów i ich rodzin. Praktyczne wskazówki dotyczące codziennego zarządzania cukrzycą.",
        "Konferencja międzynarodowa z tłumaczeniem symultanicznym. Najnowsze trendy i perspektywy rozwoju diabetologii.",
        "Warsztat praktyczny z możliwością testowania najnowszych urządzeń medycznych i technologii wspomagających leczenie.",
    ]

    private static let eventLocations = [
        "Warszawa, Hotel Marriott",
        "Kraków, Centrum Konferencyjne ICE",
        "Gdańsk, Amber Expo",
        "Wrocław, Hotel DoubleTree by Hilton",
        "Poznań, Centrum Kongresowo-Wypoczynkowe",
        "Łódź, Hotel Vienna House Easy",
        "Katowice, Międzynarodowe Centrum Kongresowe",
        "Lublin, Hotel Victoria",
        "Białystok, Hotel Branicki",
        "Szczecin, Radisson Blu Hotel",
        "Online",
        "Sopot, Hotel Sheraton",
        "Zakopane, Hotel Belvedere",
        "Kielce, Hotel Qubus",
        "Rzeszów, Hotel Hilton Garden Inn",
    ]

    private static let eventImages = [
        "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800",
        "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800",
        "https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?w=800",
        "https://images.unsplash.com/photo-1511578314322-379afb476865?w=800",
        "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800",
        "https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=800",
        "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=800",
        "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800",
    ]

    private static func generateRandomDateString(daysFromNow: Int, addRandomTime: Bool = true) -> String {
        let calendar = Calendar.current
        let baseDate = calendar.date(byAdding: .day, value: daysFromNow, to: Date()) ?? Date()

        let formatter = DateFormatter()

        if addRandomTime {
            let hour = Int.random(in: 8 ... 17)
            let minute = [0, 15, 30, 45].randomElement() ?? 0

            var components = calendar.dateComponents([.year, .month, .day], from: baseDate)
            components.hour = hour
            components.minute = minute

            let dateWithTime = calendar.date(from: components) ?? baseDate
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: dateWithTime)
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: baseDate)
        }
    }

    private static func generateEventEndDate(from startDateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let startDate = formatter.date(from: startDateString) else {
            return startDateString
        }

        let durationHours = [1, 2, 3, 4, 6, 8, 24, 48].randomElement() ?? 3
        let endDate = startDate.addingTimeInterval(TimeInterval(durationHours * 3600))

        return formatter.string(from: endDate)
    }

    public static func createSingle() -> ConferenceEvent {
        let randomId = UUID().uuidString
        let randomTitle = novoNordiskEventTitles.randomElement() ?? "Wydarzenie konferencyjne"
        let randomDescription = eventDescriptions.randomElement() ?? "Opis wydarzenia."
        let randomLocation = eventLocations.randomElement() ?? "Warszawa"
        let randomImage = eventImages.randomElement() ?? "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800"

        let daysFromNow = Int.random(in: -30 ... 90) // Events from past 30 days to next 90 days
        let startDate = generateRandomDateString(daysFromNow: daysFromNow)
        let endDate = generateEventEndDate(from: startDate)

        let isOnline = randomLocation == "Online"
        let totalSeats = isOnline ? Int.random(in: 500 ... 2000) : Int.random(in: 30 ... 300)
        let occupiedSeats = Int.random(in: 0 ... totalSeats)
        let unconfirmedSeats = Int.random(in: 0 ... (totalSeats - occupiedSeats))
        let streamUrl = isOnline ? "https://stream.novo-nordisk.com/event/\(randomId)" : nil

        return ConferenceEvent(
            id: randomId,
            title: randomTitle,
            dateFrom: startDate,
            dateTo: endDate,
            location: randomLocation,
            description: randomDescription,
            image: randomImage,
            totalSeats: totalSeats,
            occupiedSeats: occupiedSeats,
            unconfirmedSeats: unconfirmedSeats,
            isOnline: isOnline,
            streamUrl: streamUrl
        )
    }

    public static func createMany(count: Int = 10) -> [ConferenceEvent] {
        var events: [ConferenceEvent] = []

        for i in 0 ..< count {
            let id = "event_\(i + 1)"
            let title = novoNordiskEventTitles[i % novoNordiskEventTitles.count]
            let description = eventDescriptions[i % eventDescriptions.count]
            let location = eventLocations[i % eventLocations.count]
            let image = eventImages[i % eventImages.count]

            // Distribute events across different time periods
            let daysFromNow = i < count / 3 ? -Int.random(in: 1 ... 30) : // Past events
                i < 2 * count / 3 ? Int.random(in: 1 ... 30) : // Near future events
                Int.random(in: 31 ... 90) // Far future events

            let startDate = generateRandomDateString(daysFromNow: daysFromNow)
            let endDate = generateEventEndDate(from: startDate)

            let isOnline = location == "Online"
            let totalSeats = isOnline ? Int.random(in: 500 ... 2000) : Int.random(in: 30 ... 300)
            let occupiedSeats = Int.random(in: 0 ... totalSeats)
            let unconfirmedSeats = Int.random(in: 0 ... (totalSeats - occupiedSeats))
            let streamUrl = isOnline ? "https://stream.novo-nordisk.com/event/\(id)" : nil

            let event = ConferenceEvent(
                id: id,
                title: title,
                dateFrom: startDate,
                dateTo: endDate,
                location: location,
                description: description,
                image: image,
                totalSeats: totalSeats,
                occupiedSeats: occupiedSeats,
                unconfirmedSeats: unconfirmedSeats,
                isOnline: isOnline,
                streamUrl: streamUrl
            )

            events.append(event)
        }

        return events.sorted { $0.dateFrom < $1.dateFrom } // Sort by start date
    }

    public static func createUpcomingEvents(count: Int = 5) -> [ConferenceEvent] {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDateString = formatter.string(from: currentDate)

        return createMany(count: count * 2).filter { event in
            event.dateFrom > currentDateString // Only future events
        }.prefix(count).map { $0 }
    }

    public static func createPastEvents(count: Int = 5) -> [ConferenceEvent] {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDateString = formatter.string(from: currentDate)

        return createMany(count: count * 2).filter { event in
            event.dateTo < currentDateString // Only past events
        }.prefix(count).map { $0 }
    }

    public static func createOnlineEvents(count: Int = 3) -> [ConferenceEvent] {
        let onlineEvents = createMany(count: count).map { event in
            let totalSeats = Int.random(in: 500 ... 2000)
            let occupiedSeats = Int.random(in: 0 ... totalSeats)
            let unconfirmedSeats = Int.random(in: 0 ... (totalSeats - occupiedSeats))

            return ConferenceEvent(
                id: event.id,
                title: "Webinar: " + event.title.replacingOccurrences(of: "Konferencja: ", with: "").replacingOccurrences(of: "Warsztat: ", with: ""),
                dateFrom: event.dateFrom,
                dateTo: event.dateTo,
                location: "Online",
                description: event.description + " Wydarzenie odbędzie się w formie online z możliwością zadawania pytań na czacie.",
                image: event.image,
                totalSeats: totalSeats,
                occupiedSeats: occupiedSeats,
                unconfirmedSeats: unconfirmedSeats,
                isOnline: true,
                streamUrl: "https://stream.novo-nordisk.com/event/\(event.id)"
            )
        }

        return onlineEvents
    }

    public static func createEventsByMonth(year: Int, month: Int, count: Int = 10) -> [ConferenceEvent] {
        var events: [ConferenceEvent] = []

        for i in 0 ..< count {
            let id = "event_\(year)_\(month)_\(i + 1)"
            let title = novoNordiskEventTitles[i % novoNordiskEventTitles.count]
            let description = eventDescriptions[i % eventDescriptions.count]
            let location = eventLocations[i % eventLocations.count]
            let image = eventImages[i % eventImages.count]

            // Generate random day in the specified month
            let day = Int.random(in: 1 ... 28) // Safe range for all months
            let hour = Int.random(in: 8 ... 17)
            let minute = [0, 15, 30, 45].randomElement() ?? 0

            let startDate = String(format: "%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
            let endDate = generateEventEndDate(from: startDate)

            let isOnline = location == "Online"
            let totalSeats = isOnline ? Int.random(in: 500 ... 2000) : Int.random(in: 30 ... 300)
            let occupiedSeats = Int.random(in: 0 ... totalSeats)
            let unconfirmedSeats = Int.random(in: 0 ... (totalSeats - occupiedSeats))
            let streamUrl = isOnline ? "https://stream.novo-nordisk.com/event/\(id)" : nil

            let event = ConferenceEvent(
                id: id,
                title: title,
                dateFrom: startDate,
                dateTo: endDate,
                location: location,
                description: description,
                image: image,
                totalSeats: totalSeats,
                occupiedSeats: occupiedSeats,
                unconfirmedSeats: unconfirmedSeats,
                isOnline: isOnline,
                streamUrl: streamUrl
            )

            events.append(event)
        }

        return events.sorted { $0.dateFrom < $1.dateFrom }
    }

    public static func createRandomEvents(count: Int) -> [ConferenceEvent] {
        var events: [ConferenceEvent] = []
        var hasOngoingEvent = false

        for i in 0 ..< count {
            let id = "random_event_\(i + 1)"
            let title = novoNordiskEventTitles[i % novoNordiskEventTitles.count]
            let description = eventDescriptions[i % eventDescriptions.count]
            let image = eventImages[i % eventImages.count]

            // Randomly decide if event is online (30% chance)
            let isOnline = Bool.random() && Double.random(in: 0 ... 1) < 0.3
            let location = isOnline ? "Online" : eventLocations.filter { $0 != "Online" }.randomElement() ?? "Warszawa"

            let daysFromNow: Int
            let startDate: String
            let endDate: String

            // Create one ongoing event if we haven't created one yet
            if !hasOngoingEvent, i == count / 2 {
                // Create ongoing event (started 2 hours ago, ends in 2 hours)
                let now = Date()
                let startTime = now.addingTimeInterval(-2 * 3600) // 2 hours ago
                let endTime = now.addingTimeInterval(2 * 3600) // 2 hours from now

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                startDate = formatter.string(from: startTime)
                endDate = formatter.string(from: endTime)

                hasOngoingEvent = true
            } else {
                // Regular event generation
                daysFromNow = Int.random(in: -30 ... 90)
                startDate = generateRandomDateString(daysFromNow: daysFromNow)
                endDate = generateEventEndDate(from: startDate)
            }

            let totalSeats = isOnline ? Int.random(in: 500 ... 2000) : Int.random(in: 30 ... 300)
            let occupiedSeats = Int.random(in: 0 ... totalSeats)
            let unconfirmedSeats = Int.random(in: 0 ... (totalSeats - occupiedSeats))
            let streamUrl = isOnline ? "https://stream.novo-nordisk.com/event/\(id)" : nil

            let event = ConferenceEvent(
                id: id,
                title: title,
                dateFrom: startDate,
                dateTo: endDate,
                location: location,
                description: description,
                image: image,
                totalSeats: totalSeats,
                occupiedSeats: occupiedSeats,
                unconfirmedSeats: unconfirmedSeats,
                isOnline: isOnline,
                streamUrl: streamUrl
            )

            events.append(event)
        }

        return events.sorted { $0.dateFrom < $1.dateFrom }
    }
}
