import SwiftUI
import MagnusFeatures
import MagnusDomain

struct NewsListView: View {
    @State private var newsItems: [NewsItem] = NewsItemMockGenerator.createMany(count: 5)
    @State private var searchText = ""
    @EnvironmentObject var navigationManager: NavigationManager
    
    var filteredNews: [NewsItem] {
        if searchText.isEmpty {
            return newsItems
        } else {
            return newsItems.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText)
//                || item.summary.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            searchBar
                .padding(.horizontal)
                .padding(.top, 8)
            
            // News List
            if filteredNews.isEmpty {
                emptyStateView
            } else {
                newsList
            }
        }
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    private var searchBar: some View {
        HStack {
            FAIcon(.search, type: .light, size: 16, color: .gray)
            TextField("Szukaj aktualności...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private var newsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredNews) { newsItem in
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
    let newsItem: NewsItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                AsyncImage(url: URL(string: newsItem.image)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.3))
                        .overlay(FAIcon(.newspaper, type: .light, size: 40, color: .gray))
                }
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
                        Text(newsItem.formattedPublishDate)
                            .font(.caption)
                            .foregroundColor(.novoNordiskBlue)
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
