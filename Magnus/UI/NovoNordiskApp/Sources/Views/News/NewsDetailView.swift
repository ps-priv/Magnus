import SwiftUI
import MagnusFeatures
import MagnusDomain
import Kingfisher

struct NewsDetailView: View {
    let newsId: String
    @State private var newsItem: NewsItem? = NewsItemMockGenerator.createSingle()
    
    var body: some View {
        ScrollView {
            Text("News detail: \(newsId)")
//             if let newsItem = newsItem {
//                 VStack(alignment: .leading, spacing: 16) {
//                     KFImage(URL(string: newsItem.image))
//                         .placeholder {
//                             Rectangle().fill(Color.gray.opacity(0.3))
//                                 .overlay(
//                                     ProgressView()
//                                         .scaleEffect(1.5)
//                                         .tint(.novoNordiskBlue)
//                                 )
//                         }
//                         .resizable()
//                         .aspectRatio(contentMode: .fill)
//                     .frame(height: 250)
//                     .clipped()
                    
//                     VStack(alignment: .leading, spacing: 16) {
//                         Text(newsItem.title)
//                             .font(.title)
//                             .fontWeight(.bold)
                        
//                         Text(newsItem.formattedPublishDate)
//                             .font(.caption)
//                             .foregroundColor(.secondary)
                        
// //                        Text(newsItem.)
// //                            .font(.body)
                        
//                         Text("Pełna treść artykułu zostanie wyświetlona tutaj...")
//                             .font(.body)
//                             .foregroundColor(.secondary)
//                             .italic()
//                     }
//                     .padding()
                    
//                     Spacer()
//                 }
//             }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}

#Preview {
    NewsDetailView(newsId: "1")
} 
