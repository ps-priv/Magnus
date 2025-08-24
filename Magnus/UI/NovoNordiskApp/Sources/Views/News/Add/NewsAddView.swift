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
                            print("Save action")
                            print("Title: \(viewModel.title)")
                            print("Content: \(viewModel.content)")
                            //print("Image: \(viewModel.image)")
                            print("Selected groups: \(viewModel.selectedGroups)")
                            print("Attachments: \(viewModel.attachments)")
                            print("Tags: \(viewModel.tags)")
                            // Task {
                            //     await viewModel.saveNewsRequest()
                            // }
                        },
                        cancelAction: {
                            navigationManager.navigate(to: .newsList)
                        },
                        deleteAction: {
                            navigationManager.navigate(to: .newsList)
                        },
                        publishAction: {
                            // Task {
                            //     await viewModel.sendNews()
                            // }
                            print("Publish action")
                            print("Title: \(viewModel.title)")
                            print("Content: \(viewModel.content)")
                            //print("Image: \(viewModel.image)")
                            print("Selected groups: \(viewModel.selectedGroups)")
                            print("Attachments: \(viewModel.attachments)")
                            print("Tags: \(viewModel.tags)")
                        },
                        availableGroups: viewModel.groups,
                        tags: $viewModel.tags,
                        selectedGroups: $viewModel.selectedGroups,
                        attachments: $viewModel.attachments,
                        title: $viewModel.title,
                        content: $viewModel.content,
                        image: $viewModel.image,
                        canSendNews: viewModel.canSendNews())
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)   
        .background(Color.novoNordiskBackgroundGrey)
    }
}
