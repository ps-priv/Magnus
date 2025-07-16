import SwiftUI
import MagnusFeatures
import MagnusDomain

struct NewsDetailView: View {
    let newsId: String
    @State private var newsItem: NewsItem? = NewsItemMockGenerator.createSingle()
    
    var body: some View {
        ScrollView {
            if let newsItem = newsItem {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: newsItem.image)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 250)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(newsItem.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(newsItem.formattedPublishDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
//                        Text(newsItem.)
//                            .font(.body)
                        
                        Text("Pełna treść artykułu zostanie wyświetlona tutaj...")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    NewsDetailView(newsId: "1")
} 
