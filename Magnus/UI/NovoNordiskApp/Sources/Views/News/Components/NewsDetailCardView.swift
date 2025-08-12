import Kingfisher
import MagnusApplication
import MagnusDomain
import MagnusFeatures
import Pow
import SwiftUI

struct NewsDetailCardView: View {
    let news: NewsDetailCardViewDto
    let isCommentsEnabled: Bool
    let onTap: () -> Void
    let onBookmarkTap: () -> Void
    let onEditTap: () -> Void
    let onDeleteTap: () -> Void
    let onReactionTap: (ReactionEnum) -> Void
    let onCommentTap: (String) -> Void

    @State var isBookmarked: Bool
    @State var showReactionsMenu: Bool = false
    
    private enum StatsTab: CaseIterable {
        case comments
        case reactions
        case reads

        var title: String {
            switch self {
            case .comments: return LocalizedStrings.newsDetailsCommentsTab
            case .reactions: return LocalizedStrings.newsDetailsReactionsTab
            case .reads: return LocalizedStrings.newsDetailsReadsTab
            }
        }
    }
    
    @State private var selectedStatsTab: StatsTab = .comments

    init(
        news: NewsDetailCardViewDto,
        isCommentsEnabled: Bool = true,
        onTap: @escaping () -> Void,
        onBookmarkTap: @escaping () -> Void,
        onEditTap: @escaping () -> Void,
        onDeleteTap: @escaping () -> Void,
        onReactionTap: @escaping (ReactionEnum) -> Void,
        onCommentTap: @escaping (String) -> Void
    ) {
        self.news = news
        self.isCommentsEnabled = isCommentsEnabled
        self.onTap = onTap
        self.onBookmarkTap = onBookmarkTap
        self.onEditTap = onEditTap
        self.onDeleteTap = onDeleteTap
        self.onReactionTap = onReactionTap
        _isBookmarked = State(initialValue: news.isBookmarked)
        self.onCommentTap = onCommentTap
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ZStack {
                Button(action: onTap) {
                    VStack(alignment: .leading, spacing: 12) {
                        KFImage(URL(string: news.image))
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
                            .frame(height: 190)
                            .clipped()
                            .cornerRadius(12)

                        VStack(alignment: .leading) {
                            titleSection
                                .padding(.bottom, 4)
                            descriptionSection
                                .padding(.bottom, 3)
                            tagsSection
                                .padding(.bottom, 3)
                            footerSection
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.novoNordiskLightBlueBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.novoNordiskLightBlue, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                // Menu reakcji jako overlay
                if showReactionsMenu {
                    VStack(spacing: 8) {
                        // Thumbs Up
                        Button(action: {
                            onReactionTap(.THUMBS_UP)
                            showReactionsMenu = false
                        }) {
                            FAIcon(
                                FontAwesome.Icon.thumbsUp,
                                type: .thin,
                                size: 20,
                                color: Color.novoNordiskBlue
                            )
                        }
                        
                        // Heart
                        Button(action: {
                            onReactionTap(.HEART)
                            showReactionsMenu = false
                        }) {
                            FAIcon(
                                FontAwesome.Icon.heart,
                                type: .thin,
                                size: 20,
                                color: Color.novoNordiskBlue
                            )
                        }
                        
                        // Clapping Hands
                        Button(action: {
                            onReactionTap(.CLAPPING_HANDS)
                            showReactionsMenu = false
                        }) {
                            FAIcon(
                                FontAwesome.Icon.clappingHands,
                                type: .thin,
                                size: 20,
                                color: Color.novoNordiskBlue
                            )
                        }
                        
                        // Lightbulb
                        Button(action: {
                            onReactionTap(.LIGHT_BULB)
                            showReactionsMenu = false
                        }) {
                            FAIcon(
                                FontAwesome.Icon.lightBulb,
                                type: .thin,
                                size: 20,
                                color: Color.novoNordiskBlue
                            )
                        }
                        
                        // Hand with Heart
                        Button(action: {
                            onReactionTap(.HAND_HOLDING_HEART)
                            showReactionsMenu = false
                        }) {
                            FAIcon(
                                FontAwesome.Icon.handHoldingHeart,
                                type: .thin,
                                size: 20,
                                color: Color.novoNordiskBlue
                            )
                        }
                        
                        // Thumbs Down
                        Button(action: {
                            onReactionTap(.THUMBS_DOWN)
                            showReactionsMenu = false
                        }) {
                            FAIcon(
                                FontAwesome.Icon.thumbsDown,
                                type: .thin,
                                size: 20,
                                color: Color.novoNordiskBlue
                            )
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: -10, y: -180) 
                    .zIndex(1000)
                    .transition(.opacity.combined(with: .scale))
                }
            }
            tabSection
        }
    }

    @ViewBuilder
    var titleSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(news.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(PublishedDateHelper.formatPublishDate(news.publish_date))
                    .font(.system(size: 12))
                    .foregroundColor(Color.novoNordiskBlue)
            }
            Spacer()
            HStack(spacing: 15) {
                bookmarkedSection
                editSection
            }
        }
    }

    @ViewBuilder
    var bookmarkedSection: some View {
        Button(action: {
            onBookmarkTap()
            isBookmarked.toggle()
        }) {
            //if !news.is_bookmarked {
            if isBookmarked {
                FAIcon(
                    FontAwesome.Icon.bookmark,
                    type: .light,
                    size: 16,
                    color: Color.novoNordiskTextGrey
                )
            } else {
                FAIcon(
                    FontAwesome.Icon.bookmark,
                    type: .solid,
                    size: 16,
                    color: Color.novoNordiskLightBlue
                )
            }
        }
        .changeEffect(
            .spray(origin: UnitPoint(x: 0.25, y: 0.5)) {
                if !isBookmarked {
                    FAIcon(
                        FontAwesome.Icon.bookmark,
                        type: .solid,
                        size: 25,
                        color: Color.novoNordiskLightBlue
                    )
                }
            }, value: isBookmarked)
    }

    @ViewBuilder
    var editSection: some View {
        Menu {
            Button {
                onEditTap()
            } label: {
                Label(LocalizedStrings.newsListEditNews, systemImage: "pencil")
            }

            Button(role: .destructive) {
                onDeleteTap()
            } label: {
                Label(LocalizedStrings.newsListDeleteNews, systemImage: "trash")
            }
        } label: {
            FAIcon(
                FontAwesome.Icon.ellipsisVertical,
                type: .light,
                size: 16,
                color: Color.novoNordiskTextGrey
            )
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .background(Color.white)
        //.shadow(color: .black.opacity(0.9), radius: 12, x: 0, y: 0)
    }

    @ViewBuilder
    var descriptionSection: some View {
        Text(news.description)
            .font(.novoNordiskBody)
    }

    @ViewBuilder
    var footerSection: some View {
        HStack {
            authorSection
            Spacer()
            newsStatsSection
        }
    }

    @ViewBuilder
    var authorSection: some View {
        HStack {
            FAIcon(
                FontAwesome.Icon.userCircle,
                type: .thin,
                size: 25,
                color: Color.novoNordiskBlue
            )
            VStack(alignment: .leading) {
                Text(news.author.name)
                    .font(.novoNordiskAuthorName)
                Text(news.author.groups)
                    .font(.novoNordiskAuthorGroups)
                    .foregroundColor(Color.novoNordiskBlue)
            }
        }
    }

    @ViewBuilder
    var tagsSection: some View {
        Text(news.tags)
            .font(.novoNordiskSmallText)
            .foregroundColor(Color.novoNordiskTextGrey)
    }

    private let menuItems = ContextMenu {
        Button(action: {
            print("Thumbs Up tapped")
        }) {
            Label("Thumbs Up", systemImage: "hand.thumbsup")
        }

        Button(action: {
            print("Thumbs Up tapped")
        }) {
            Label("Thumbs Up", systemImage: "hand.thumbsup")
        }
    }

    @ViewBuilder
    var reactionsSection: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                showReactionsMenu.toggle()
            }
        }) {
            HStack(spacing: 2) {
                FAIcon(
                    FontAwesome.Icon.smile,
                    type: .light,
                    size: 14,
                    color: Color.novoNordiskTextGrey
                )
                Text(String(news.reactions_count))
                    .font(.novoNordiskSmallText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
        }
    }


    @ViewBuilder
    var newsStatsSection: some View {
        HStack {
            HStack(spacing: 2) {
                FAIcon(
                    FontAwesome.Icon.eye,
                    type: .light,
                    size: 14,
                    color: Color.novoNordiskTextGrey
                )
                Text(String(news.read_count))
                    .font(.novoNordiskSmallText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            HStack(spacing: 2) {
                FAIcon(
                    FontAwesome.Icon.comment,
                    type: .light,
                    size: 14,
                    color: Color.novoNordiskTextGrey
                )
                Text(String(news.comments_count))
                    .font(.novoNordiskSmallText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
            reactionsSection
        }
    }

    @ViewBuilder
    var tabSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 16) {
                ForEach(StatsTab.allCases, id: \.self) { tab in
                    Button(action: { selectedStatsTab = tab }) {
                        Text(tab.title)
                            .font(.system(size: 14))
                            .fontWeight(selectedStatsTab == tab ? .bold : .regular)
                            .foregroundColor(Color.novoNordiskBlue)
                    }
                    .buttonStyle(.plain)
                }
            }

            Group {
                switch selectedStatsTab {
                case .comments:
                    VStack {
                        CommentsListForNews(comments: news.comments)
                        if isCommentsEnabled {
                            CreateCommentForNewsView(onSendTap: onCommentTap, onCancelTap: {})
                        }
                    }

                case .reactions:
                    ReactionListForNews(reactions: news.reactions)

                case .reads:
                    ReadListForNews(read: news.read)
                }
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 8)
        }
        .padding(.top, 10)
    }
}

#Preview("JSON") {
    let news: NewsDetailCardViewDto = NewsDetailCardViewDtoMock.fromProvidedJson()

    VStack(alignment: .leading){
        NewsDetailCardView(
            news: news,
            isCommentsEnabled: true,    
            onTap: {
                print("Tapped")
            },
            onBookmarkTap: {
                print("Tapped")
            },
            onEditTap: {
                print("Tapped")
            },
            onDeleteTap: {
                print("Tapped")
            },
            onReactionTap: { reaction in
                print("Reaction tapped: \(reaction)")
            },
            onCommentTap: { text in
                print("Comment tapped: \(text)")
            })
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(20)
    .background(Color.novoNordiskBackgroundGrey)
 }
