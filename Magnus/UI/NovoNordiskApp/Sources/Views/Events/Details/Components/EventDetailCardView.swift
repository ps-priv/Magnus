import Kingfisher
import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventDetailCardView: View {
    let event: ConferenceEventDetails
    let eventId: String
    @EnvironmentObject var navigationManager: NavigationManager

    init(event: ConferenceEventDetails, eventId: String) {
        self.event = event
        self.eventId = eventId
    }

    var body: some View {
        VStack(spacing: 0) {
            EventNavigationBar
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            ScrollView(.vertical, showsIndicators: true) {
                EventDetailsSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
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

                if event.guardians.count > 0 {
                    EventManagerSection
                        .padding(.top, 8)
                        .padding(.bottom, 3)
                }

                if event.location.name != "" {
                    EventLocationContactSection
                        .padding(.top, 8)
                        .padding(.bottom, 3)
                }

            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.novoNordiskLighGreyForPanelBackground)
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
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

            ForEach(event.guardians, id: \.email) { guardian in
                if guardian.hasName() {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(guardian.name)
                            .font(.novoNordiskMiddleText)
                            .fontWeight(.bold)
                            .foregroundColor(Color.novoNordiskTextGrey)

                        if guardian.hasEmail() {
                            Button {
                                if let url = URL(string: "mailto:\(guardian.email)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                HStack {
                                    FAIcon(FontAwesome.Icon.email, type: .light, size: 16, color: .novoNordiskBlue)
                                    Text(guardian.email)
                                        .font(.novoNordiskMiddleText)
                                        .foregroundColor(Color.novoNordiskTextGrey)
                                }
                            }
                        }

                        if guardian.hasPhone() {
                            Button {
                                if let url = URL(string: "tel:\(guardian.phone)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                HStack {
                                    FAIcon(FontAwesome.Icon.phone, type: .light, size: 16, color: .novoNordiskBlue)
                                    Text(guardian.phone)
                                        .font(.novoNordiskMiddleText)
                                        .foregroundColor(Color.novoNordiskTextGrey)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
            }
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
                FAIcon(FontAwesome.Icon.location, type: .light, size: 16, color: .novoNordiskBlue)
                Text(event.location.getFullAddress())
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }

            if event.location.hasEmail() {
                Button {
                    if let url = URL(string: "mailto:\(event.location.email)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        FAIcon(FontAwesome.Icon.email, type: .light, size: 16, color: .novoNordiskBlue)
                        Text(event.location.email)
                            .font(.novoNordiskMiddleText)
                            .foregroundColor(Color.novoNordiskTextGrey)
                    }
                }
            }

            if event.location.hasPhone() {
                Button {
                    if let url = URL(string: "tel:\(event.location.phone)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        FAIcon(FontAwesome.Icon.phone, type: .light, size: 16, color: .novoNordiskBlue)
                        Text(event.location.phone)
                            .font(.novoNordiskMiddleText)
                            .foregroundColor(Color.novoNordiskTextGrey)
                    }
                }
            }

            if event.location.hasWww() {
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
        HStack(spacing: 10) {
            Button {
                print("Event button tapped")
            } label: {
                HStack(spacing: 4) {
                    FAIcon(FontAwesome.Icon.calendar, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.eventTabEvent)
                        .font(.novoNordiskMiddleText)
                        .fontWeight(.bold)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .contentShape(Rectangle())
            }

            Button {
                print("Materials button tapped - eventId: \(eventId)")
                navigationManager.navigateToEventMaterials(eventId: eventId)
            } label: {
                HStack(spacing: 4) {
                    FAIcon(FontAwesome.Icon.file, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.eventTabMaterials)
                        .font(.novoNordiskMiddleText)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .contentShape(Rectangle())
            }

            Button {
                print("Gallery button tapped - eventId: \(eventId)")
                navigationManager.navigateToEventGallery(eventId: eventId)
            } label: {
                HStack(spacing: 4) {
                    FAIcon(FontAwesome.Icon.image, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.eventTabPhotobooth)
                        .font(.novoNordiskMiddleText)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .contentShape(Rectangle())
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
            EventDetailCardView(event: event, eventId: "1")
                .environmentObject(NavigationManager())
        } else {
            Text("Event not found")
        }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}

#Preview("EventDetailCardViewChM") {

    let event = EventDetailsJsonMockGenerator.generateObjectChM()

    VStack {
        if let event = event {
            EventDetailCardView(event: event, eventId: "1")
                .environmentObject(NavigationManager())
        } else {
            Text("Event not found")
        }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}
