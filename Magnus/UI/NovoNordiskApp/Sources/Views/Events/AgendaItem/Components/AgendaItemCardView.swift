import Foundation
import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct AgendaItemCardView: View {
    let agendaItem: ConferenceEventAgendaContent
    let location: ConferenceEventLocation
    let action: () -> Void

    init(
        agendaItem: ConferenceEventAgendaContent, location: ConferenceEventLocation,
        action: @escaping () -> Void
    ) {
        self.agendaItem = agendaItem
        self.location = location
        self.action = action
    }

    var body: some View {
        VStack(alignment: .leading) {
            titleSection

            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    agendaTitleSection
                        .padding(.bottom, 10)
                    locationSection
                        .padding(.bottom, 10)
                    speakersSection
                        .padding(.bottom, 10)

                    descriptionSection
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    var titleSection: some View {
        HStack {
            Button(action: action) {
                FAIcon(
                    FontAwesome.Icon.circle_arrow_left,
                    type: .regular,
                    size: 24,
                    color: Color.novoNordiskBlue
                )

                Text(TimeHelper.formatPublishDate(agendaItem.time_from))
                    .font(.novoNordiskSectionTitle)
                    .foregroundColor(Color.novoNordiskBlue)
                Text(" - ")
                    .font(.novoNordiskSectionTitle)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(TimeHelper.formatPublishDate(agendaItem.time_to))
                    .font(.novoNordiskSectionTitle)
                    .foregroundColor(Color.novoNordiskBlue)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }

    @ViewBuilder
    var agendaTitleSection: some View {
        VStack {
            Text(agendaItem.title)
                .font(.novoNordiskHeadline)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
        }
    }

    @ViewBuilder
    var locationSection: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.novoNordiskMiddleText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
            HStack {
                Text(location.city)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(" | ")
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(location.street)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
            Text(agendaItem.place)
                .font(.novoNordiskMiddleText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
        }
    }

    @ViewBuilder
    var speakersSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(LocalizedStrings.eventAgendaSpeaker)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(agendaItem.speakers)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
            HStack {
                Text(LocalizedStrings.eventAgendaPresenter)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(agendaItem.presenters)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
        }
    }

    @ViewBuilder
    var descriptionSection: some View {
        Text(agendaItem.description)
            .font(.novoNordiskBody)
            .foregroundColor(Color.novoNordiskTextGrey)
    }   
}

#Preview("AgendaItemCardView") {

    var agenda = ConferenceEventAgendaContent(
        time_from: "10:00:00",
        time_to: "10:45:00",
        place: "Sala niebieska",
        title: "Rozpoczęcie",
        speakers: "Andrzej Borek",
        presenters: "Novo Nordisk",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        is_quiz: 0,
        is_online: 0)

    var location = ConferenceEventLocation(
        name: "Novotel Warszawa Centrum",
        city: "Warszawa",
        zip_code: "00-510",
        street: "Marszałkowska 94/98",
        latitude: "52.229367",
        longitude: "21.013171",
        image: "https://nncv2-dev.serwik.pl/images/Novotel_Warszawa.jpeg",
        phone: "+48 22 548 42 72",
        email: "H3383@accor.com",
        www:
            "https://all.accor.com/booking/pl/novotel/hotels/warsaw-poland?compositions=1&stayplus=false&order_hotels_by=RECOMMENDATION&snu=false&hideWDR=false&productCode=null&accessibleRooms=false&hideHotelDetails=false&filters=eyJicmFuZHMiOlsiTk9WIl19&utm_term=mar&utm_campaign=ppc-nov-mar-msn-pl-pl-ee_ai-mix-sear&utm_medium=cpc&msclkid=4078f0543dce1ea8ccb798db5d8bb6c4&utm_source=bing&utm_content=pl-pl-PL-V4333",
        header_description: "Sala bursztynowa",
        description:
            "Hotel, który sprawia, że liczy się każda chwila\n\nZarezerwuj pokój w czterogwiazdkowym Novotel Warszawa Centrum ze wspaniałymi widokami na tętniącą życiem Warszawę. Hotel położony jest tylko 5 minut spacerem od Dworca Centralnego, a bliskość zabytków, sklepów i instytucji kultury zachęcają do zwiedzania. Wyśmienite jedzenie gwarantują hotelowy bar i restauracja. Śniadania są serwowane w dwóch restauracjach, na poziomie 0 oraz -1. W Novotelu dbamy również o udane spotkania biznesowe, a naszym gościom oferujemy doskonale wyposażone centrum konferencyjne.\n\nHotel Novotel Warszawa Centrum (hotel średniej klasy dla biznesu i rodziny) mieści się w samym centrum Warszawy niedaleko słynnego Pałacu Kultury i Nauki. Znajdujący się przy hotelu węzeł komunikacyjny (metro, autobusy i tramwaje) zapewnia dobrą komunikację z głównymi atrakcjami stolicy. Do hotelu można dojechać tramwajem z oddalonego o 500 m dworca, a z Lotniska Chopina kursuje bezpośredni autobus oraz Szybka Kolej Miejska. Podróż trwa ok. 25 min. Główne drogi dojazdowe to E30 i E77.\n\nZarezerwuj pokój w czterogwiazdkowym Novotel Warszawa Centrum ze wspaniałymi widokami na tętniącą życiem Warszawę. Wyśmienite jedzenie gwarantują hotelowy bar i restauracja. W Novotelu dbamy również o udane spotkania biznesowe i konferencje."
    )

    VStack {
        AgendaItemCardView(agendaItem: agenda, location: location, action: {})
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(20)
    .background(Color.novoNordiskBackgroundGrey)
}
