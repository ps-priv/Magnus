import Kingfisher
import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI
import Pow

struct NewsListCardView: View {
    @EnvironmentObject private var navigationManager: NavigationManager

    let news: News
    let onTap: () -> Void
    let onBookmarkTap: () -> Void
    let onEditTap: () -> Void
    let onDeleteTap: () -> Void

    @State var isBookmarked: Bool
    @State var allowEdit: Bool
    var userPermissions: UserPermissions

    init(news: News, userPermissions: UserPermissions, onTap: @escaping () -> Void, onBookmarkTap: @escaping () -> Void, onEditTap: @escaping () -> Void, onDeleteTap: @escaping () -> Void) {
        self.news = news
        self.onTap = onTap
        self.onBookmarkTap = onBookmarkTap
        self.onEditTap = onEditTap
        self.onDeleteTap = onDeleteTap
        _isBookmarked = State(initialValue: news.isBookmarked)
        self.userPermissions = userPermissions
        self.allowEdit = userPermissions.canEditNews(newsAuthorId: news.author.id)
    }

    var body: some View {
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
                                    FAIcon(.newspaper, type: .light, size: 40, color: Color.novoNordiskGrey)
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
                    .padding(.bottom, 6)
                    footerSection
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

    @ViewBuilder
    var titleSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(news.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
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
            if !isBookmarked {
                FAIcon(
                    FontAwesome.Icon.bookmark,
                    type: .light,
                    size: 25,
                    color: Color.novoNordiskTextGrey
                )
            } else {
                FAIcon(
                    FontAwesome.Icon.bookmark,
                    type: .solid,
                    size: 25,
                    color: Color.novoNordiskLightBlue
                )
            }            
        }
        .changeEffect(
            .spray(origin: UnitPoint(x: 0.25, y: 0.5)) {
                if isBookmarked {
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
        if allowEdit {
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
                size: 18,
                color: Color.novoNordiskTextGrey
            )
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .background(Color.white)
        //.shadow(color: .black.opacity(0.9), radius: 12, x: 0, y: 0)
        }
    }

    @ViewBuilder
    var descriptionSection: some View {
        ClickableTextView(text: news.description)
            .font(.novoNordiskBody)
            .foregroundColor(Color.novoNordiskTextGrey)
            .lineLimit(4)
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
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(news.author.groups)
                    .font(.novoNordiskAuthorGroups)
                    .foregroundColor(Color.novoNordiskBlue)
            }
        }
    }

    @ViewBuilder
    var newsStatsSection: some View {
        HStack {
            HStack (spacing: 2) {    
                FAIcon(
                    FontAwesome.Icon.eye,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskTextGrey
                )
                Text(String(news.read_count))
                    .font(.novoNordiskSmallText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            HStack (spacing: 2) {    
                FAIcon(
                    FontAwesome.Icon.comment,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskTextGrey
                )
                Text(String(news.comments_count))
                    .font(.novoNordiskSmallText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            HStack (spacing: 2) {    
                FAIcon(
                    FontAwesome.Icon.smile,
                    type: .light,
                    size: 20,
                    color: Color.novoNordiskTextGrey
                )
                Text(String(news.reactions_count))
                    .font(.novoNordiskSmallText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
        }
    }
}

#Preview {
    var news: News = ApiNewsMock.getSingleNews()

    let userPermissions = UserPermissions(id: "1", admin: 1, news_editor: 1, photo_booths_editor: 1)

    VStack {
        NewsListCardView(news: news, 
        userPermissions: userPermissions,
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
        })
    }
    .padding(20)
    .background(Color(.systemGray6))
}
