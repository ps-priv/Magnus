import SwiftUI
import MagnusFeatures

struct NewsAddView: View {

    @StateObject private var viewModel: NewsAddViewModel = NewsAddViewModel()
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingIndicator()
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
                            print("Publish action start")
                            Task {
                                await viewModel.sendNews()
                                if !viewModel.hasError {
                                    // Wait 5 seconds before redirecting to news list
                                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                                    await MainActor.run {
                                        navigationManager.navigate(to: .newsList)
                                    }
                                }
                            }  
                            print("Publish action end")                       
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
        .contentShape(Rectangle())
        .onTapGesture { hideKeyboard() }
        .scrollDismissesKeyboard(.interactively)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)   
        .background(Color.novoNordiskBackgroundGrey)
        // .toast(isPresented: $viewModel.showToast, message: viewModel.message)
    }
}

// MARK: - Keyboard helpers
private extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
