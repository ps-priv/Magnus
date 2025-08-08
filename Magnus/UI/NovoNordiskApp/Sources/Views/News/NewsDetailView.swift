import Kingfisher
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct NewsDetailView: View {
    let newsId: String
    @StateObject private var viewModel: NewsDetailsViewModel

    init(newsId: String) {
        self.newsId = newsId
        _viewModel = StateObject(wrappedValue: NewsDetailsViewModel(id: newsId))
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text(viewModel.news?.title ?? "No title")
               // NewsDetailCardView(news: NewsDetailCardViewDto.fromNewsDetails(newsDetails: viewModel.news ?? NewsDetails()), onTap: {}, onBookmarkTap: {}, onEditTap: {}, onDeleteTap: {}, onReactionTap: {})
            }
        }.background(Color.novoNordiskBackgroundGrey)
    }
}

// #Preview {
//     NewsDetailView(newsId: "1")
// }
