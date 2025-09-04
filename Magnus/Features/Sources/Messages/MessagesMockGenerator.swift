import Foundation
import MagnusDomain

public class MessagesMockGenerator {
    
    private static let novoNordiskTitles = [
        "Nowa era w leczeniu cukrzycy z Novo Nordisk",
        "Innowacyjne rozwiązania diabetologiczne od Novo Nordisk",
        "Przełom w terapii GLP-1 - badania Novo Nordisk",
        "Najnowsze wytyczne diabetologiczne 2025",
        "Ozempic® - nowe możliwości w terapii cukrzycy",
        "Wegovy® w walce z otyłością - najnowsze badania",
        "Technologie wspomagające samokontrolę cukrzycy",
        "Badania kliniczne nad nowymi lekami Novo Nordisk",
        "Rybelsus® - pierwsza tabletka GLP-1 na polskim rynku",
        "Edukacja pacjentów z cukrzycą - program Novo Nordisk",
        "Profilaktyka powikłań cukrzycy - nowe standardy",
        "Semaglutyd w praktyce klinicznej - doświadczenia lekarzy",
        "Insulina degludec - długodziałająca kontrola glukozy",
        "Tresiba® FlexTouch® - wygoda w codziennej terapii",
        "Novo Nordisk Way - filozofia zorientowana na pacjenta",
        "Diabetologia przyszłości - wizja Novo Nordisk 2030"
    ]
    
    private static let loremWords = [
        "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit", "sed", "do",
        "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore", "magna", "aliqua", "enim",
        "ad", "minim", "veniam", "quis", "nostrud", "exercitation", "ullamco", "laboris", "nisi", "aliquip",
        "ex", "ea", "commodo", "consequat", "duis", "aute", "irure", "in", "reprehenderit", "voluptate",
        "velit", "esse", "cillum", "fugiat", "nulla", "pariatur", "excepteur", "sint", "occaecat", "cupidatat",
        "non", "proident", "sunt", "culpa", "qui", "officia", "deserunt", "mollit", "anim", "id",
        "est", "laborum", "at", "vero", "eos", "accusamus", "dignissimos", "ducimus", "blanditiis",
        "praesentium", "voluptatum", "deleniti", "atque", "corrupti", "quos", "dolores", "quas", "molestias"
    ]
    
    private static let sampleDates = [
        "2025-01-20", "2025-01-19", "2025-01-18", "2025-01-17", "2025-01-16",
        "2025-01-15", "2025-01-14", "2025-01-13", "2025-01-12", "2025-01-11",
        "2025-01-10", "2025-01-09", "2025-01-08", "2025-01-07", "2025-01-06"
    ]

    private static let sampleTimes = [
        "08:00", "09:00", "10:00", "11:00", "12:00",
        "13:00", "14:00", "15:00", "16:00", "17:00"
    ]
    
    private static func generateLoremContent(length: Int) -> String {
        var content = ""
        let targetLength = max(100, min(1000, length))  
        
        while content.count < targetLength {
            let randomWord = loremWords.randomElement() ?? "lorem"
            if content.isEmpty {
                content = randomWord.capitalized
            } else {
                content += " " + randomWord
            }
            
            // Add punctuation occasionally
            if content.count > 50 && Int.random(in: 1...20) == 1 {
                content += ". "
                if content.count < targetLength - 20 {
                    content += loremWords.randomElement()?.capitalized ?? "Lorem"
                }
            }
        }
        
        // Ensure proper ending
        if !content.hasSuffix(".") && !content.hasSuffix("!") && !content.hasSuffix("?") {
            content += "."
        }
        
        return String(content.prefix(targetLength))
    }
    
    public static func createSingle() -> ConferenceMessage {
        let randomId = UUID().uuidString
        let randomTitle = novoNordiskTitles.randomElement() ?? "Komunikat konferencyjny"
        let randomDate = sampleDates.randomElement() ?? "2025-01-15"
        let randomTime = sampleTimes.randomElement() ?? "08:00"
        let randomImageId = Int.random(in: 300...399)
        let randomIsRead = Bool.random()
        
        return ConferenceMessage(
            id: randomId,
            title: randomTitle,
            publish_date: randomDate,
            publish_time: randomTime,
            picture: "https://picsum.photos/400/\(randomImageId)",
            is_read: randomIsRead
        )
    }
    
    public static func createMany(count: Int = 10) -> [ConferenceMessage] {
        var messages: [ConferenceMessage] = []
        
        for i in 0..<count {
            let id = "message_\(i + 1)"
            let title = novoNordiskTitles[i % novoNordiskTitles.count]
            let date = sampleDates[i % sampleDates.count]
            let time = sampleTimes[i % sampleTimes.count]
            let imageId = 300 + (i % 100)
            let isRead = i % 3 != 0 // About 2/3 of messages are read
            
            let message = ConferenceMessage(
                id: id,
                title: title,
                publish_date: date,
                publish_time: time,
                picture: "https://picsum.photos/400/\(imageId)",
                is_read: isRead
            )
            
            messages.append(message)
        }
        
        return messages
    }
    
    public static func createUnreadMessages(count: Int = 5) -> [ConferenceMessage] {
        return createMany(count: count).map { message in
            ConferenceMessage(
                id: message.id,
                title: message.title,
                publish_date: message.publish_date,
                publish_time: message.publish_time,
                picture: message.picture,
                is_read: false
            )
        }
    }
    
    public static func createReadMessages(count: Int = 5) -> [ConferenceMessage] {
        return createMany(count: count).map { message in
            ConferenceMessage(
                id: message.id,
                title: message.title,
                publish_date: message.publish_date,
                publish_time: message.publish_time,
                picture: message.picture,
                is_read: true
            )
        }
    }
}
