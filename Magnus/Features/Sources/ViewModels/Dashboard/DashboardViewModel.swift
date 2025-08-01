import Combine
import Foundation
import MagnusApplication
import MagnusDomain
import SwiftUI

@MainActor
public class DashboardViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published public var dashboardData: DashboardResponse?
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    /// Check if dashboard has any data
    public var hasData: Bool {
        guard let data = dashboardData else { return false }
        return !data.news.isEmpty || !data.events.isEmpty || !data.materials.isEmpty
    }

    private let dashboardService: DashboardService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(dashboardService: DashboardService = DIContainer.shared.dashboardService) {
        self.dashboardService = dashboardService
        Task {
            await loadDashboard()
        }
    }

    // MARK: - Setup
    /// Load dashboard data
    public func loadDashboard() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data = try await dashboardService.getDashboard()

            print("data: \(data)")

            await MainActor.run {
                dashboardData = data
                isLoading = false
            }

        } catch let error {
            SentryHelper.capture(error: error, action: "DashboardViewModel.loadDashboard")
            await handleError(error)
        }
    }

    /// Get news item by ID
    public func getNewsItem(by id: String) -> NewsItem? {
        return dashboardData?.news.first { $0.id == id }
    }

    /// Get event item by ID
    public func getEventItem(by id: String) -> EventItem? {
        return dashboardData?.events.first { $0.id == id }
    }

    /// Get material item by ID
    public func getMaterialItem(by id: String) -> MaterialItem? {
        return dashboardData?.materials.first { $0.id == id }
    }

    // MARK: - Private Methods

    private func handleError(_ error: Error) async {
        let message: String

        if let dashboardError = error as? DashboardError {
            switch dashboardError {
            case .networkError(let details):
                message = "Błąd sieci: \(details)"
            case .serverError(let code):
                message = "Błąd serwera: \(code)"
            case .noData:
                message = "Brak danych do wyświetlenia"
            case .invalidResponse:
                message = "Nieprawidłowa odpowiedź serwera"
            case .unknown:
                message = "Wystąpił nieoczekiwany błąd"
            }
        } else {
            message = "Nie udało się załadować danych"
        }

        await MainActor.run {
            errorMessage = message
            hasError = true
            isLoading = false
        }
    }
}

// MARK: - Dashboard Error Types

public enum DashboardError: Error, LocalizedError {
    case networkError(String)
    case serverError(Int)
    case noData
    case invalidResponse
    case unknown

    public var errorDescription: String? {
        switch self {
        case .networkError(let details):
            return "Network error: \(details)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .noData:
            return "No data available"
        case .invalidResponse:
            return "Invalid server response"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
