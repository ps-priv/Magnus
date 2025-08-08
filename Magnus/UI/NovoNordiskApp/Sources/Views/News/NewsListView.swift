import SwiftUI
import MagnusFeatures
import MagnusDomain
import Kingfisher

struct NewsListView: View {

    @StateObject private var viewModel: NewsListViewModel = NewsListViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                newsList
            }
        }
        .background(Color(.systemGray6))
    }
     
    @ViewBuilder
    private var newsList: some View {
        if viewModel.news.isEmpty {
            emptyStateView
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.news) { newsItem in
                        NewsListCardView(news: newsItem, 
                            onTap: {
                                navigationManager.navigateToNewsDetail(newsId: newsItem.id)
                            },
                            onBookmarkTap: {
                                Task {
                                    await viewModel.changeNewsBookmarkStatus(id: newsItem.id)
                                }
                            },
                            onEditTap: {
                                //navigationManager.navigateToNewsEdit(newsId: newsItem.id)
                            },
                            onDeleteTap: {
                                Task {
                                    await viewModel.deleteNews(id: newsItem.id)
                                }
                            })
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            FAIcon(.newspaper, type: .light, size: 60, color: .gray)
            Text("Brak aktualności")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Text("Nie znaleziono aktualności spełniających kryteria wyszukiwania")
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
    .background(Color(.systemGray6))
} 
