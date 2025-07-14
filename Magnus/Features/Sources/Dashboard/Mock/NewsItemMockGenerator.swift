import Foundation
import MagnusDomain

public class NewsItemMockGenerator {
    
    private static let sampleTitles = [
        "Nowe badania nad cukrzycą typu 2",
        "Innowacyjne metody leczenia insuliną",
        "Przełom w terapii diabetologicznej", 
        "Najnowsze wytyczne diabetologiczne",
        "Technologie wspomagające leczenie cukrzycy",
        "Badania kliniczne nad nowymi lekami",
        "Dieta w cukrzycy - najnowsze zalecenia",
        "Pompy insulinowe nowej generacji",
        "Edukacja pacjentów z cukrzycą",
        "Profilaktyka powikłań cukrzycy"
    ]
    
    private static let sampleDates = [
        "2024-01-15", "2024-01-14", "2024-01-13", "2024-01-12", "2024-01-11",
        "2024-01-10", "2024-01-09", "2024-01-08", "2024-01-07", "2024-01-06"
    ]
    
    public static func createSingle() -> NewsItem {
        let randomId = UUID().uuidString
        let randomTitle = sampleTitles.randomElement() ?? "Przykładowa aktualność"
        let randomDate = sampleDates.randomElement() ?? "2024-01-15"
        let randomImageId = Int.random(in: 200...299)
        
        return NewsItem(
            id: randomId,
            title: randomTitle,
            publish_date: randomDate,
            image: "https://picsum.photos/200/\(randomImageId)"
        )
    }
    
    public static func createMany(count: Int = 10) -> [NewsItem] {
        var newsItems: [NewsItem] = []
        
        for i in 0..<count {
            let id = "news_\(i + 1)"
            let title = sampleTitles[i % sampleTitles.count]
            let date = sampleDates[i % sampleDates.count]
            let imageId = 200 + (i % 100)
            
            let newsItem = NewsItem(
                id: id,
                title: title,
                publish_date: date,
                image: "https://picsum.photos/200/\(imageId)"
            )
            
            newsItems.append(newsItem)
        }
        
        return newsItems
    }
} 