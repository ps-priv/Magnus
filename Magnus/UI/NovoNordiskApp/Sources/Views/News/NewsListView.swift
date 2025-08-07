import SwiftUI
import MagnusFeatures
import MagnusDomain
import Kingfisher

struct NewsListView: View {

    @StateObject private var viewModel: NewsListViewModel = NewsListViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
//     var filteredNews: [NewsItem] {
//         if searchText.isEmpty {
//             return newsItems
//         } else {
//             return newsItems.filter { item in
//                 item.title.localizedCaseInsensitiveContains(searchText)
// //                || item.summary.localizedCaseInsensitiveContains(searchText)
//             }
//         }
//     }
    
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
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.news) { newsItem in
                    NewsListCardView(newsItem: newsItem) {
                        navigationManager.navigateToNewsDetail(newsId: newsItem.id)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
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

struct NewsListCardView: View {
    let newsItem: News
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                KFImage(URL(string: newsItem.image))
                    .placeholder {
                        Rectangle().fill(Color.gray.opacity(0.3))
                            .overlay(
                                VStack {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .tint(.novoNordiskBlue)
                                    FAIcon(.newspaper, type: .light, size: 40, color: .gray)
                                        .padding(.top, 8)
                                }
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(newsItem.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
//                    Text(newsItem.summary)
//                        .font(.body)
//                        .foregroundColor(.secondary)
//                        .lineLimit(3)
                    
                    HStack {
                        FAIcon(.clock, type: .light, size: 14, color: .novoNordiskBlue)
                        // Text(newsItem.formattedPublishDate)
                        //     .font(.caption)
                        //     .foregroundColor(.novoNordiskBlue)
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NewsListView()
        .environmentObject(NavigationManager())
} 
