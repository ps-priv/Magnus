import MagnusDomain
import MagnusFeatures
import SwiftUI

struct NewsGroupsView: View {

    @StateObject private var viewModel = NewsGroupsViewModel()
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                newsList
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }

    @ViewBuilder
    private var newsList: some View {
        if viewModel.groups.isEmpty {
            emptyStateView
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    NewsGroupsCardView(groups: viewModel.groups)
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
            Text(LocalizedStrings.newsGroupsEmptyStateTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Text(LocalizedStrings.newsGroupsEmptyStateDescription)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
}
