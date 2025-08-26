import Kingfisher
import MagnusDomain
import MagnusFeatures
import SwiftUI
import PopupView

struct NewsDetailView: View {
    let newsId: String
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel: NewsDetailsViewModel

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
                                    print("Tapped")
                                },
                                onEditTap: {
                                    navigationManager.navigateToNewsEdit(newsId: newsId)
                                },
                                onDeleteTap: {
                                    print("Tapped")
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
                                })
                                .toast(isPresented: $viewModel.showPopup, message: viewModel.popupMessage)
                                .padding(.top, 16)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                    }
                    else {
                        NewsDetailsNotFound()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.novoNordiskBackgroundGrey)
    }
}