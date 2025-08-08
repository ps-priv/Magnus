import SwiftUI
import MagnusFeatures
import MagnusDomain
import Kingfisher

struct NewsDetailView: View {
    let newsId: String
    @StateObject private var viewModel: NewsDetailsViewModel

    init(newsId: String) {
        self.newsId = newsId
        _viewModel = StateObject(wrappedValue: NewsDetailsViewModel(id: newsId))
    }
    
    var body: some View {
        ScrollView {
   

        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}

#Preview {
    NewsDetailView(newsId: "1")
} 
