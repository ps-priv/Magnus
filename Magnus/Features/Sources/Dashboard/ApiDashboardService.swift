import Combine
import Foundation
import MagnusApplication
import MagnusDomain

public class ApiDashboardService: DashboardService {

    private let authStorageService: AuthStorageService
    private let dashboardNetworkService: DashboardNetworkServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    public init(
        authStorageService: AuthStorageService,
        dashboardNetworkService: DashboardNetworkServiceProtocol
    ) {
        self.authStorageService = authStorageService
        self.dashboardNetworkService = dashboardNetworkService
    }

    public func getDashboard() async throws -> DashboardResponse {

        let token = try authStorageService.getAccessToken() ?? ""

        print("token: \(token)")
        SentryHelper.capture(message: "token: \(token)")

        let dashboardResponse = try await withCheckedThrowingContinuation { continuation in
            dashboardNetworkService.getDashboardData(token: token)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                    }
                )
                .store(in: &cancellables)
        }

        print("dashboardResponse: \(dashboardResponse)")
        SentryHelper.capture(message: "dashboardResponse: \(dashboardResponse)")

        return dashboardResponse
    }
}
