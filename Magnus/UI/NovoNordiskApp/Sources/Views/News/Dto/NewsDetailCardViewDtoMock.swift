import Foundation
import MagnusDomain
import MagnusFeatures

public class NewsDetailCardViewDtoMock {
    public static func getSingleNews() -> NewsDetailCardViewDto {
        return NewsDetailCardViewDto(
            id: "eyJpZCI6MiwidG9rZW4iOiIxMHxxUm5lUDEyQzIyOGsxUHhrZkV1THRLV09yUWo0Tjg2MlVCZXhmRlI1MGFkMTU0MDQifQ", 
            publish_date: "2025-01-03 12:30:20", 
            title: "Test newsa informacyjnego", 
            description: DescriptionMock.getLongDescription(),
            isBookmarked: Bool.random(),
            author: ApiAuthorMock.getAuthor(), 
            read_count: 87,
            reactions_count: 12,
            comments_count: 5,
            image: "https://nncv2-dev.serwik.pl/images/th-4109958356.jpeg",
            tags: "Test, News, Informacyjny",
            comments: [],
            reactions: []
            // read: [],
            // attachments: []
        )
    }

    public static func fromProvidedJson() -> NewsDetailCardViewDto {
        // JSON provided in the request
        let json = """
        {
            "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
            "publish_date": "2025-01-02 12:30:20",
            "title": "Gratulujemy Zwycięzcom CDC Poland Simply The Best Awards",
            "description": "Mamy przyjemność przedstawić Wam Zwycięzców nagród rocznych 2024 CDC Poland Simply The Best Awards, którzy zostali ogłoszeni podczas uroczystej gali na spotkaniu Mid Year Meeting CDC Poland w Janowie Podlaskim.   Nagrody CDC Poland Simply The Best są nie tylko symbolem uznania naszych liderów oraz Kolegów i Koleżanek, ale przede wszystkim świadectwem najwyższych standardów działania i doskonałych rezultatów osiąganych przez nasze Zespoły! GRATULUJEMY!",
            "image": "https://nncv2-dev.serwik.pl/images/1_Gratulujemy_Zwyciezcom_CDC_Poland.jpg",
            "highlight_entry": 0,
            "block_comments": 0,
            "block_reactions": 0,
            "author": {
                "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                "name": "Joanna Skarżyńska-Kotyńska",
                "groups": "Kardiologia, Badania i rozwój"
            },
            "tags": [
                "Cukrzyca",
                "Dieta",
                "Waga"
            ],
            "groups": [
                {
                    "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                    "name": "Kardiologia"
                },
                {
                    "id": "eyJpZCI6MiwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                    "name": "Badania i rozwój"
                }
            ],
            "isBookmarked": true,
            "read_count": 1,
            "reactions_count": 1,
            "comments_count": 2,
            "comments": [
                {
                    "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                    "message": "aaa Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                    "created_at": "2025-08-07 20:22:37",
                    "author": {
                        "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                        "name": "Joanna Skarżyńska-Kotyńska",
                        "groups": "Kardiologia, Badania i rozwój"
                    }
                },
                {
                    "id": "eyJpZCI6MiwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                    "message": "bbb Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                    "created_at": "2025-08-07 20:22:37",
                    "author": {
                        "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                        "name": "Joanna Skarżyńska-Kotyńska",
                        "groups": "Kardiologia, Badania i rozwój"
                    }
                }
            ],
            "reactions": [
                {
                    "reaction": 2,
                    "author": {
                        "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                        "name": "Joanna Skarżyńska-Kotyńska",
                        "groups": "Kardiologia, Badania i rozwój"
                    }
                }
            ],
            "read": [
                {
                    "author": {
                        "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                        "name": "Joanna Skarżyńska-Kotyńska",
                        "groups": "Kardiologia, Badania i rozwój"
                    }
                }
            ],
            "attachments": [
                {
                    "id": "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9",
                    "title": "",
                    "link": "https://novonordisk.sharepoint.com/sites/Poland/SitePages/Zwyci%C4%99zcy-Simply-The-Best-CDC-Poland.aspx?source=https%3A%2F%2Fnovonordisk.sharepoint.com%2Fsites%2FPoland",
                    "file_type": 4
                }
            ]
        }
        """

        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        do {
            let details = try decoder.decode(NewsDetails.self, from: data)
            return NewsDetailCardViewDto.fromNewsDetails(newsDetails: details)
        } catch {
            // Fallback to existing mock on decode failure
            return getSingleNews()
        }
    }
}