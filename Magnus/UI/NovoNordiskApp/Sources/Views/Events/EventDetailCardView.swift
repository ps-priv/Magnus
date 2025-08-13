import Kingfisher
import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventDetailCardView: View {
    let event: ConferenceEventDetails
    @EnvironmentObject var navigationManager: NavigationManager

    init(event: ConferenceEventDetails) {
        self.event = event
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading) {
                EventNavigationBar
                EventDetailsSection
            }
        }
    }

    @ViewBuilder
    var EventDetailsSection: some View {

        VStack(alignment: .leading, spacing: 12) {
            KFImage(URL(string: event.image))
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
                TitleSection
                    .padding(.bottom, 4)

                EventDateSection
                    .padding(.bottom, 4)

                EventShortLocationSection
                    .padding(.bottom, 3)

                EventDescriptionSection
                    .padding(.bottom, 3)

                EventManagerSection
                    .padding(.top, 8)
                    .padding(.bottom, 3)

                EventLocationContactSection
                    .padding(.top, 8)
                    .padding(.bottom, 3)

            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    var TitleSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .lineLimit(2)
            }
            Spacer()
        }
    }

    @ViewBuilder
    var EventDateSection: some View {
        HStack {
            FAIcon(FontAwesome.Icon.calendar, type: .regular, size: 18, color: .novoNordiskBlue)
            Text(
                PublishedDateHelper.formatDateRangeForEvent(
                    event.date_from, event.date_to, LocalizedStrings.months,
                    dateFormat: "yyyy-MM-dd")
            )
            .font(.headline)
            .foregroundColor(Color.novoNordiskTextGrey)
            EventStatusView(date_from: event.date_from, date_to: event.date_to)
        }
    }

    @ViewBuilder
    var EventShortLocationSection: some View {
        HStack {
            VStack {
                FAIcon(FontAwesome.Icon.location, type: .regular, size: 18, color: .novoNordiskBlue)
                    .padding(.top, 2)
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(event.location.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)

                Text(event.location.getLocationAddress())
                    .font(.novoNordiskRegularText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
        }
    }

    @ViewBuilder
    var EventManagerSection : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStrings.eventEventManager)
                .font(.novoNordiskRegularText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
        }
    }   

    @ViewBuilder
    var EventLocationContactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStrings.eventLocationContact)
                .font(.novoNordiskRegularText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)

            Text(event.location.name)
                .font(.novoNordiskMiddleText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)

            HStack {
                FAIcon(FontAwesome.Icon.location, type: .light, size: 18, color: .novoNordiskBlue)
                Text(event.location.getFullAddress())
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            HStack {
                FAIcon(FontAwesome.Icon.email, type: .light, size: 18, color: .novoNordiskBlue)
                Text(event.location.email)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            HStack {
                FAIcon(FontAwesome.Icon.phone, type: .light, size: 18, color: .novoNordiskBlue)
                Text(event.location.phone)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            HStack {
                FAIcon(FontAwesome.Icon.fileUrl, type: .light, size: 18, color: .novoNordiskBlue)
                Button {
                    if let url = URL(string: event.location.www) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(event.location.getDomainAddressFromWww())
                        .font(.novoNordiskMiddleText)
                        .underline()
                        .foregroundColor(Color.novoNordiskBlue)
                }
            }
        }
    }

    @ViewBuilder
    var EventDescriptionSection: some View {
        HStack {
            Text(event.description)
                .font(.novoNordiskRegularText)
                .foregroundColor(Color.novoNordiskTextGrey)
        }
    }

    @ViewBuilder
    var EventNavigationBar: some View {
        HStack(spacing: 15) {
            Button(action: {
                //navigationManager.popToRoot()
            }) {
                FAIcon(FontAwesome.Icon.calendar, type: .light, size: 16, color: .novoNordiskBlue)
                Text(LocalizedStrings.eventTabEvent)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Button(action: {
                //navigationManager.popToRoot()
            }) {
                FAIcon(FontAwesome.Icon.file, type: .light, size: 16, color: .novoNordiskBlue)
                Text(LocalizedStrings.eventTabMaterials)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Button(action: {
                //navigationManager.popToRoot()
            }) {
                FAIcon(FontAwesome.Icon.image, type: .light, size: 16, color: .novoNordiskBlue)
                Text(LocalizedStrings.eventTabPhotobooth)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Spacer()

            giftsSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    var giftsSection: some View {
        Menu {
            Button {
                // onEditTap()
            } label: {
                Label(LocalizedStrings.eventGifts, systemImage: "pencil")
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
    }
}

#Preview("EventDetailCardView") {

    let event = EventDetailsJsonMockGenerator.generateObject()

    VStack {
        if let event = event {
            EventDetailCardView(event: event)
                .environmentObject(NavigationManager())
        } else {
            Text("Event not found")
        }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}
