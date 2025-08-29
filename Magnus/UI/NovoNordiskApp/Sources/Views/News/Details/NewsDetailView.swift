import Kingfisher
import MagnusDomain
import MagnusFeatures
import PopupView
import SwiftUI

struct NewsDetailView: View {
    let newsId: String
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel: NewsDetailsViewModel
    @State private var showDeleteConfirmation: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    init(newsId: String) {
        self.newsId = newsId
        _viewModel = StateObject(wrappedValue: NewsDetailsViewModel(id: newsId))
    }

    var body: some View {

        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if viewModel.news != nil {
                    NewsDetailCardView(
                        news: NewsDetailCardViewDto.fromNewsDetails(newsDetails: viewModel.news!),
                        isCommentsEnabled: viewModel.isCommentsEnabled,
                        onTap: {
                            print("Tapped")
                        },
                        onBookmarkTap: {
                            Task {
                                await viewModel.changeNewsBookmarkStatus()
                            }
                        },
                        onEditTap: {
                            navigationManager.navigateToNewsEdit(newsId: newsId)
                        },
                        onDeleteTap: {
                            showDeleteConfirmation = true
                        },
                        onReactionTap: { reaction in
                            Task {
                                await viewModel.sendNewsReaction(reaction: reaction)
                            }
                        },
                        onCommentTap: { text in
                            Task {
                                await viewModel.addCommentToNews(comment: text)
                            }
                        },
                        allowEdit: viewModel.allowEdit
                    )
                    .toast(isPresented: $viewModel.showPopup, message: viewModel.popupMessage)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                } else {
                    NewsDetailsNotFound()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.novoNordiskBackgroundGrey)
        .novoNordiskAlert(
            isPresented: $showDeleteConfirmation,
            title: LocalizedStrings.newsDeleteConfirmationMessage,
            message: nil,
            icon: .delete,
            primaryTitle: LocalizedStrings.deleteButton,
            primaryStyle: .destructive,
            primaryAction: {
                Task {
                    await viewModel.deleteNews()
                }
                //showToast = true
                toastMessage = LocalizedStrings.newsDeletedMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    navigationManager.navigateToTabRoot(.news)
                }
            },
            secondaryTitle: LocalizedStrings.cancelButton,
            secondaryStyle: .cancel,
            secondaryAction: {
                // Cancel tapped
            }
        )
        .toast(isPresented: $showToast, message: toastMessage)
    }
}
