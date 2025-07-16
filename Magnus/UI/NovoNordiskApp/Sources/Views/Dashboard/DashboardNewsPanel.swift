import SwiftUI
import MagnusFeatures
import MagnusApplication
import MagnusDomain

struct DashboardNewsPanel: View {
    
    @Binding var items: [NewsItem]
    @State private var currentPage: Int = 0
    
    var body: some View {
        VStack {
            titleSection
            newsCards
            Spacer()
        }
        .padding(20)
    }
    
    @ViewBuilder
    var titleSection: some View {
        HStack {
            FAIcon(
                FontAwesome.Icon.newspaper,
                type: .thin,
                size: 24,
                color: Color.novoNordiskBlue
            )
            Text(LocalizedStrings.dashboardNewsTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .lineLimit(1)
            Spacer()
            NovoNordiskLinkButton(icon: FontAwesome.Icon.circle_arrow_right,
                title: LocalizedStrings.dashboardEventsSectionLoadMore, style: .standard) {
                print("Standard link tapped")
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
                .onChange(of: currentPage) { newValue in
                    // Handle page change if needed
                }
                
                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0..<items.count, id: \.self) { index in
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
    let item: NewsItem
    
    var body: some View {
        VStack(spacing: 0) {
            // Image section
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        FAIcon(.newspaper, type: .light, size: 40, color: .gray)
                    )
            }
            .frame(height: 140)
            .clipped()
            
            // Content section
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.novoNordiskBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(PublishedDateHelper.formatPublishDate(item.publish_date))
                    .font(.novoNordiskCaption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(12)
        //.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
}


