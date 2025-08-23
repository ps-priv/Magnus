import SwiftUI
import MagnusFeatures

struct NewsAddView: View {

    @StateObject private var viewModel: NewsAddViewModel = NewsAddViewModel()
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
            } else {
                VStack {
                    NewsAddCardView(
                        saveAction: {
                            Task {
                                await viewModel.saveNewsRequest()
                            }
                        },
                        cancelAction: {
                            navigationManager.navigate(to: .newsList)
                        },
                        deleteAction: {
                            navigationManager.navigate(to: .newsList)
                        },
                        publishAction: {
                            Task {
                                await viewModel.sendNews()
                            }
                        },
                        availableGroups: viewModel.groups,
                        tags: viewModel.tags,
                        selectedGroups: viewModel.selectedGroups,
                        attachments: viewModel.attachments,
                        title: viewModel.title,
                        content: viewModel.content,
                        image: viewModel.image,
                        canSendNews: viewModel.canSendNews())
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)   
        .background(Color.novoNordiskBackgroundGrey)
    }
}
