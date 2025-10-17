import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventAgendaItem: View {
    let agendaItem: ConferenceEventAgendaContent
    let storageService: MagnusStorageService

    init(
        agendaItem: ConferenceEventAgendaContent,
        storageService: MagnusStorageService = DIContainer.shared.storageService
    ) {
        self.agendaItem = agendaItem
        self.storageService = storageService
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(TimeHelper.formatPublishDate(agendaItem.time_from))
                    .font(.novoNordiskSectionTitle)
                    .foregroundColor(Color.novoNordiskBlue)
                Text(TimeHelper.formatPublishDate(agendaItem.time_to))
                    .font(.novoNordiskSectionTitle)
                    .foregroundColor(Color.novoNordiskBlue)

                if !agendaItem.place.isEmpty {
                    Text("|")
                        .font(.novoNordiskSectionTitle)
                        .foregroundColor(Color.novoNordiskTextGrey)
                    Text(agendaItem.place)
                        .font(.novoNordiskRegularText)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                Spacer()
                // if TimeHelper.isNow(agendaItem.time_from, agendaItem.time_to) {
                //     eventStatusIndicator
                // }
            }
            .padding(.bottom, 6)

            HStack {
                Text(agendaItem.title)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
                Spacer()

            }
            .padding(.bottom, 6)

            if !agendaItem.speakers.isEmpty {
                HStack {
                    Text("\(LocalizedStrings.eventAgendaSpeaker): ")
                        .font(.novoNordiskMiddleText)
                        .fontWeight(.bold)
                        .foregroundColor(Color.novoNordiskBlue)
                    Text(agendaItem.speakers)
                        .font(.novoNordiskMiddleText)
                        .foregroundColor(Color.novoNordiskBlue)
                    Spacer()
                }
            }
            
            if !agendaItem.presenters.isEmpty {
                HStack {
                    Text("\(LocalizedStrings.eventAgendaPresenter): ")
                        .font(.novoNordiskMiddleText)
                        .fontWeight(.bold)
                        .foregroundColor(Color.novoNordiskBlue)
                    Text(agendaItem.presenters)
                        .font(.novoNordiskMiddleText)
                        .foregroundColor(Color.novoNordiskBlue)
                    Spacer()
                }
            }

            Text(agendaItem.description)
                .font(.novoNordiskMiddleText)
                .foregroundColor(Color.novoNordiskTextGrey)
                .lineLimit(3)
                .padding(.top, 4)
                .padding(.bottom, 4)

            HStack {
                
                // EventAgendaJoinOnlineButton(
                //     isOnline: agendaItem.is_online, action: { print("AgendaItemButtonTapped") })
                // if agendaItem.is_quiz == 1 {
                //     EventAgendaQuizButton(action: { print("AgendaItemButtonTapped") })
                // }
                Spacer()
                Button(action: {
                    navigateToAgendaItem()
                }) {
                    HStack {
                        Text(LocalizedStrings.load_more)
                            .font(.novoNordiskRegularText)
                            .foregroundColor(Color.novoNordiskBlue)
                        FAIcon(.circle_arrow_right, type: .light, size: 16, color: .novoNordiskBlue)
                            .padding(.top, 4)
                    }
                }
            }

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    var eventStatusIndicator: some View {
        HStack {
            Text(LocalizedStrings.eventInProgress)
                .font(.novoNordiskMiddleText)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
        }
        .background(Color.novoNordiskLightBlue)
        .cornerRadius(10)
    }

    private func navigateToAgendaItem() {

        do {
            try storageService.saveAgendaItem(agendaItem: agendaItem)
            NavigationManager.shared.navigate(to: .eventAgendaItem(eventId: ""))
        } catch {
            print("Error saving agenda item: \(error)")
        }
    }
}

#Preview("EventAgendaItem - Quiz, online") {
    let agendaItem = EventAgendaMock.getEventAgendaContent(
        hasQuiz: true, hasOnline: true, timeFrom: "18:00:00", timeTo: "19:7:00")
    VStack {
        EventAgendaItem(agendaItem: agendaItem)
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}

#Preview("EventAgendaItem") {
    let agendaItem = EventAgendaMock.getEventAgendaContent(hasQuiz: false, hasOnline: false)
    VStack {
        EventAgendaItem(agendaItem: agendaItem)
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey)
}
