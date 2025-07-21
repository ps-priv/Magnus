import Foundation
import MagnusDomain

public class ConferenceMaterialsMockGenerator {
    private static let materialTitles = [
        "Przewodnik po najnowszych terapiach GLP-1",
        "Praktyczne zastosowanie systemów CGM",
        "Insulin degludec - instrukcja stosowania",
        "Semaglutyd w praktyce klinicznej",
        "Wegovy - kompleksowa dokumentacja produktu",
        "Tresiba FlexTouch - przewodnik u|ytkownika",
        "Ozempic - badania kliniczne i efektywnościś",
        "Rybelsus - pierwsza doustna terapia GLP-1",
        "Nowoczesna diabetologia - kompendium wiedzy",
        "Monitorowanie glukozy - najlepsze praktyki",
        "Profilaktyka powikłań cukrzycy",
        "Technologie wspomagające leczenie",
        "Personalizacja terapii diabetologicznej",
        "Lifestyle medicine w diabetologii",
        "Najnowsze wytyczne PTD 2025",
        "Insulinoterapia - praktyczne aspekty",
        "Diabetologia przyszłości - raport",
    ]

    private static let eventNames = [
        "Konferencja Novo Nordisk 2025",
        "Warsztat Diabetologiczny Warszawa",
        "Webinar GLP-1 Masterclass",
        "Sympozjum Ozempic Experience",
        "Szkolenie Wegovy Specialists",
        "Panel CGM Technologies",
        "Konferencja Tresiba Expert",
        "Diabetologia Future Summit",
    ]

    private static func generateRandomDateString(daysFromNow: Int = 0) -> String {
        let calendar = Calendar.current
        let baseDate = calendar.date(byAdding: .day, value: daysFromNow, to: Date()) ?? Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: baseDate)
    }

    public static func createSingleForEvent(eventId: String, eventName: String) -> ConferenceMaterial {
        let randomTitle = materialTitles.randomElement() ?? "Materiał konferencyjny"
        let randomType = ConferenceMaterialType.allCases.randomElement() ?? .pdf
        let daysFromNow = Int.random(in: -7 ... 0) // ConferenceMaterials from past week
        let publicationDate = generateRandomDateString(daysFromNow: daysFromNow)

        return ConferenceMaterial(
            id: UUID().uuidString,
            title: randomTitle,
            type: randomType,
            publicationDate: publicationDate,
            eventId: eventId,
            eventName: eventName
        )
    }

    public static func createManyForEvent(eventId: String, eventName: String, count: Int) -> [ConferenceMaterial] {
        var materials: [ConferenceMaterial] = []

        for i in 0 ..< count {
            let title = materialTitles[i % materialTitles.count]
            let type = ConferenceMaterialType.allCases[i % ConferenceMaterialType.allCases.count]
            let daysFromNow = Int.random(in: -14 ... 0) // ConferenceMaterials from past 2 weeks
            let publicationDate = generateRandomDateString(daysFromNow: daysFromNow)

            let material = ConferenceMaterial(
                id: UUID().uuidString,
                title: title,
                type: type,
                publicationDate: publicationDate,
                eventId: eventId,
                eventName: eventName
            )

            materials.append(material)
        }

        return materials.sorted { $0.publicationDate > $1.publicationDate } // Sort by publication date, newest first
    }

    public static func createSingle() -> ConferenceMaterial {
        let randomTitle = materialTitles.randomElement() ?? "Materiał edukacyjny"
        let randomType = ConferenceMaterialType.allCases.randomElement() ?? .pdf
        let daysFromNow = Int.random(in: -30 ... 0) // ConferenceMaterials from past month
        let publicationDate = generateRandomDateString(daysFromNow: daysFromNow)

        // 30% chance to have associated event
        let hasEvent = Bool.random() && Double.random(in: 0 ... 1) < 0.3
        let eventId = hasEvent ? "event_\(Int.random(in: 1 ... 10))" : nil
        let eventName = hasEvent ? eventNames.randomElement() : nil

        return ConferenceMaterial(
            id: UUID().uuidString,
            title: randomTitle,
            type: randomType,
            publicationDate: publicationDate,
            eventId: eventId,
            eventName: eventName
        )
    }

    public static func createMany(count: Int = 10) -> [ConferenceMaterial] {
        var materials: [ConferenceMaterial] = []

        for i in 0 ..< count {
            let title = materialTitles[i % materialTitles.count]
            let type = ConferenceMaterialType.allCases[i % ConferenceMaterialType.allCases.count]
            let daysFromNow = -Int.random(in: 0 ... 60) // ConferenceMaterials from past 2 months
            let publicationDate = generateRandomDateString(daysFromNow: daysFromNow)

            // 40% chance to have associated event
            let hasEvent = i % 5 < 2 // Every 2nd and 3rd material has event
            let eventId = hasEvent ? "event_\(Int.random(in: 1 ... 8))" : nil
            let eventName = hasEvent ? eventNames.randomElement() : nil

            let material = ConferenceMaterial(
                id: UUID().uuidString,
                title: title,
                type: type,
                publicationDate: publicationDate,
                eventId: eventId,
                eventName: eventName
            )

            materials.append(material)
        }

        return materials.sorted { $0.publicationDate > $1.publicationDate } // Sort by publication date, newest first
    }

    public static func createRecentConferenceMaterials(count: Int = 5) -> [ConferenceMaterial] {
        var materials: [ConferenceMaterial] = []

        for i in 0 ..< count {
            let title = materialTitles[i % materialTitles.count]
            let type = ConferenceMaterialType.allCases.randomElement() ?? .pdf
            let daysFromNow = -Int.random(in: 0 ... 7) // ConferenceMaterials from past week
            let publicationDate = generateRandomDateString(daysFromNow: daysFromNow)

            let material = ConferenceMaterial(
                id: UUID().uuidString,
                title: "< " + title,
                type: type,
                publicationDate: publicationDate,
                eventId: nil,
                eventName: nil
            )

            materials.append(material)
        }

        return materials.sorted { $0.publicationDate > $1.publicationDate }
    }

    public static func createConferenceMaterialsByType(type: ConferenceMaterialType, count: Int = 5) -> [ConferenceMaterial] {
        var materials: [ConferenceMaterial] = []

        for i in 0 ..< count {
            let title = materialTitles[i % materialTitles.count]
            let daysFromNow = -Int.random(in: 0 ... 30)
            let publicationDate = generateRandomDateString(daysFromNow: daysFromNow)

            let hasEvent = Bool.random() && Double.random(in: 0 ... 1) < 0.5
            let eventId = hasEvent ? "event_\(Int.random(in: 1 ... 5))" : nil
            let eventName = hasEvent ? eventNames.randomElement() : nil

            let material = ConferenceMaterial(
                id: UUID().uuidString,
                title: title,
                type: type,
                publicationDate: publicationDate,
                eventId: eventId,
                eventName: eventName
            )

            materials.append(material)
        }

        return materials.sorted { $0.publicationDate > $1.publicationDate }
    }

    public static func createRandomMany(count: Int) -> [ConferenceMaterial] {
        var materials: [ConferenceMaterial] = []

        for i in 0 ..< count {
            let title = materialTitles[i % materialTitles.count]
            let type = ConferenceMaterialType.allCases.randomElement() ?? .pdf
            let daysFromNow = -Int.random(in: 0 ... 90) // ConferenceMaterials from past 3 months
            let publicationDate = generateRandomDateString(daysFromNow: daysFromNow)

            // Randomly decide if this material is associated with an event (50% chance)
            let hasEvent = Bool.random()
            let eventId = hasEvent ? "event_\(Int.random(in: 1 ... 20))" : nil
            let eventName = hasEvent ? eventNames.randomElement() : nil

            let material = ConferenceMaterial(
                id: UUID().uuidString,
                title: title,
                type: type,
                publicationDate: publicationDate,
                eventId: eventId,
                eventName: eventName
            )

            materials.append(material)
        }

        return materials.sorted { $0.publicationDate > $1.publicationDate }
    }
}
