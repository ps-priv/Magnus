import Foundation
import MagnusDomain

public class ApiAuthorMock  {
    public static func getAuthor() -> Author {
        return Author(
            id: "eyJpZCI6MiwidG9rZW4iOiIxMHxxUm5lUDEyQzIyOGsxUHhrZkV1THRLV09yUWo0Tjg2MlVCZXhmRlI1MGFkMTU0MDQifQ", 
            name: "Joanna Skarżyńska-Kotyńska", 
            groups: "Kardiologia, Badania i rozwój")
    }
}