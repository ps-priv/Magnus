import Foundation
import Combine
import MagnusDomain

@MainActor
public class NewsGroupsViewModel: ObservableObject {
    @Published public var groups: [NewsGroup] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var hasError: Bool = false

    private let newsService: ApiNewsService

    public init(newsService: ApiNewsService = DIContainer.shared.newsService) {
        self.newsService = newsService

        Task {
            await loadData()
        }
    }

    public func loadData() async {
        await MainActor.run {
            isLoading = true
            hasError = false
            errorMessage = ""
        }

        do {
            let data: GetGroupsResponse = try await newsService.getGroups()
            await MainActor.run {
                groups = data.groups
                isLoading = false
            }
        } catch {
            await MainActor.run {
                hasError = true
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }

    public func createGroup(name: String) async {
        // await MainActor.run {
        //     isLoading = true
        //     hasError = false
        //     errorMessage = ""
        // }

        // do {
        //     let data: CreateGroupResponse = try await newsService.createGroup(name: name)
        //     await MainActor.run {
        //         groups = data.groups
        //         isLoading = false
        //     }
        // } catch {
        //     await MainActor.run {
        //         hasError = true
        //         errorMessage = error.localizedDescription
        //         isLoading = false
        //     }
        // }
    }
}
