import Foundation
import MagnusDomain
import MagnusApplication

public class DashboardServiceMock: DashboardService {
    public init() {}

    public func getDashboard() async throws -> DashboardResponse {

        try await Task.sleep(nanoseconds: 1_000_000_000) // 1.0 seconds

        let news: [NewsItem] = NewsItemMockGenerator.createMany(count: 3)

        return DashboardResponse(news: news, events: [], materials: [])
    }
}