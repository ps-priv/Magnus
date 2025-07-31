import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI
import Kingfisher

#if DEBUG
    import Inject
#endif

struct DashboardNewsPanel: View {
    #if DEBUG
        @ObserveInjection var inject
    #endif

    @Binding var items: [NewsItem]
    @State private var currentPage: Int = 0
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            titleSection
            newsCards
            Spacer()
        }
    }

    @ViewBuilder
    var titleSection: some View {
        HStack {
            FAIcon(
                FontAwesome.Icon.newspaper,
                type: .thin,
                size: 21,
                color: Color.novoNordiskBlue
            )
            Text(LocalizedStrings.dashboardNewsTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .lineLimit(1)
            Spacer()
            NovoNordiskLinkButton(icon: FontAwesome.Icon.circle_arrow_right,
                                  title: LocalizedStrings.dashboardEventsSectionLoadMore,
                                  style: .small)
            {
                navigationManager.navigate(to: .newsList)
            }
        }
        .padding(0)
    }

    @ViewBuilder
    var newsCards: some View {
        VStack(spacing: 16) {
            if !items.isEmpty {
                TabView(selection: $currentPage) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, newsItem in
                        NewsItemCard2(item: newsItem)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 220)

                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.novoNordiskBlue : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 8)
            } else {
                Text("Brak aktualności")
                    .font(.novoNordiskBody)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

struct NewsItemCard2: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let item: NewsItem

    var body: some View {
        VStack(spacing: 0) {
            // Image section
            KFImage(URL(string: item.image))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            FAIcon(.newspaper, type: .light, size: 40, color: .gray)
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
            .frame(height: 140)
            .clipped()

            // Content section
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.novoNordiskBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                HStack {
                    Text(PublishedDateHelper.formatPublishDate(item.publish_date))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: { navigationManager.navigateToNewsDetail(newsId: item.id) }) {
                        FAIcon(.circle_arrow_right, type: .light, size: 21, color: .novoNordiskBlue)
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 4)
    }
}

#Preview("DashboardNewsPanel") {
    struct PreviewWrapper: View {
        @State var items = NewsItemMockGenerator.createMany(count: 3)
        var body: some View {
            DashboardNewsPanel(items: $items)
        }
    }
    return PreviewWrapper()
        .environmentObject(NavigationManager())
}
