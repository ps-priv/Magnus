import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI
#if DEBUG
    import Inject
#endif

struct DashboardMaterialsPanel: View {
    #if DEBUG
        @ObserveInjection var inject
    #endif

    @Binding var items: [MaterialItem]
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            if !items.isEmpty {
                DashboardMaterialsCard(items: $items, action: { navigationManager.navigate(to: .materialsList) })
                Spacer()
            }
        }
    }
}

struct DashboardMaterialsCard: View {
    @Binding var items: [MaterialItem]
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            titleSection
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top) {
                    FAIcon(
                        FileTypeConverter.getIcon(from: item.file_type),
                        type: .thin,
                        size: 21,
                        color: Color.novoNordiskTextGrey
                    )
                    .padding(.top, 5)
                    .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.novoNordiskBody)
                            .foregroundColor(Color.novoNordiskTextGrey)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        VStack {
                            Text(PublishedDateHelper.formatDateForEvent(item.publication_date, LocalizedStrings.months))
                                .font(.system(size: 14))
                                .foregroundColor(.novoNordiskBlue)
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            footerSection
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    var titleSection: some View {
        HStack {
            FAIcon(
                FontAwesome.Icon.fileChartColumn,
                type: .thin,
                size: 21,
                color: Color.novoNordiskBlue
            )
            Text(LocalizedStrings.dashboardMaterialsTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .lineLimit(1)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }

    @ViewBuilder
    var footerSection: some View {
        HStack {
            Spacer()
            NovoNordiskLinkButton(icon: FontAwesome.Icon.circle_arrow_right,
                                  title: LocalizedStrings.dashboardEventsSectionLoadMore,
                                  style: .small)
            {
                action()
            }
            .padding(.bottom, 10)
            .padding(.top, 10)
            .padding(.trailing, 0)
            .padding(.leading, 10)
        }
        .padding(.trailing, 10)
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }
}

// #Preview("DashboardUpcomingEventsCard") {
//     let items = ConferenceMaterialsMockGenerator.createMany(count: 3)
//     VStack {
//         DashboardMaterialsCard(items: items, action: {})
//         Spacer()
//     }.padding(10)
// }
