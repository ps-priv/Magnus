import Foundation
import MagnusDomain

public class ApiNewsMock {
    public static func getSingleNews() -> News {
        return News(
            id: "eyJpZCI6MiwidG9rZW4iOiIxMHxxUm5lUDEyQzIyOGsxUHhrZkV1THRLV09yUWo0Tjg2MlVCZXhmRlI1MGFkMTU0MDQifQ", 
            publish_date: "2025-01-03 12:30:20", 
            title: "Test newsa informacyjnego", 
            description: DescriptionMock.getLongDescription(),
            isBookmarked: Bool.random(),
            author: ApiAuthorMock.getAuthor(), 
            read_count: 87,
            reactions_count: 12,
            comments_count: 5,
            image: "https://nncv2-dev.serwik.pl/images/th-4109958356.jpeg"
        )
    }

    public static func getGroups() -> GetGroupsResponse {
        return GetGroupsResponse(
            groups: [
                NewsGroup(id: "1", name: "Badania i rozwój"),
                NewsGroup(id: "2", name: "Kardiologia"),
                NewsGroup(id: "3", name: "Ortopedia")
            ]
        )
    }
} 