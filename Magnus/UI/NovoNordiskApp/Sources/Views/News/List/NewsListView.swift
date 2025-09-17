import Kingfisher
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct NewsListView: View {

    @State private var showDeleteConfirmation: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var selectedNewsId: String = ""

    @StateObject private var viewModel: NewsListViewModel = NewsListViewModel()
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                LoadingIndicator()
            } else {
                newsList
            }
        }
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
                    await viewModel.deleteNews(id: selectedNewsId)
                    await viewModel.loadData()
                }
                showToast = true
                toastMessage = LocalizedStrings.newsDeletedMessage
            },
            secondaryTitle: LocalizedStrings.cancelButton,
            secondaryStyle: .cancel,
            secondaryAction: {
                // Cancel tapped
            }
        )
        .toast(isPresented: $showToast, message: toastMessage)
    }

    @ViewBuilder
    private var newsList: some View {
        searchSection
        if viewModel.news.isEmpty {
            emptyStateView
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.news) { newsItem in
                        NewsListCardView(
                            news: newsItem,
                            currentUserId: viewModel.currentUserId,
                            onTap: {
                                navigationManager.navigateToNewsDetail(newsId: newsItem.id)
                            },
                            onBookmarkTap: {
                                Task {
                                    await viewModel.changeNewsBookmarkStatus(id: newsItem.id)
                                }
                            },
                            onEditTap: {
                                navigationManager.navigateToNewsEdit(newsId: newsItem.id)
                            },
                            onDeleteTap: {
                                showDeleteConfirmation = true
                                selectedNewsId = newsItem.id
                            },
                            allowEdit: viewModel.allowEdit)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private var searchSection: some View {
        HStack {
            NovoNordiskTextBox(
                placeholder: LocalizedStrings.newsSearchPlaceholder,
                text: $viewModel.searchText
            )

            NovoNordiskIconButton(icon: .search, title: LocalizedStrings.newsSearchButton, style: .primary) {
                Task {
                    await viewModel.searchNews()
                }
            }
            .frame(width: 120)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            FAIcon(.newspaper, type: .light, size: 60, color: .gray)
            Text(LocalizedStrings.newsEmptyStateTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Text(LocalizedStrings.newsEmptyStateDescription)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
}

#Preview {
    VStack {
        NewsListView()
            .environmentObject(NavigationManager())
    }
    .padding(20)
    .background(Color.novoNordiskBackgroundGrey)
}
