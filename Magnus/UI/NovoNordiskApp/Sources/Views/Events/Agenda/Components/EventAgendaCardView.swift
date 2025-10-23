import MagnusDomain
import MagnusFeatures
import MagnusApplication
import SwiftUI
import Foundation

struct EventAgendaCardView: View {
    let event: ConferenceEventDetails
    @State private var selectedDayIndex: Int = 0
    @State private var agendaItems: [ConferenceEventAgendaContent] = []
    @State private var days: [EventAgendaTabItem] = []

    init(event: ConferenceEventDetails) {
        self.event = event
    }

    private func loadDays() {

        if event.agenda.isEmpty {
            return
        }

        var currentDayIndex: Int = 0

        for agendaItem in event.agenda {
            let date = PublishedDateHelper.formatDateForEvent(agendaItem.date, LocalizedStrings.months, dateFormat: "yyyy-MM-dd")     
            let dateCaption = "\(LocalizedStrings.eventAgendaDay) \(agendaItem.day)" 
            
            days.append(EventAgendaTabItem(id: currentDayIndex, title: dateCaption, subtitle: date))
            currentDayIndex += 1
        }

        selectedDayIndex = 0
    }
  
    var body: some View {
        VStack(alignment: .leading) {
            eventTitleSection
            eventDaysSection
            eventAgendaSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.novoNordiskBackgroundGrey)
        .onAppear {
            loadDays()
            if event.agenda.indices.contains(selectedDayIndex) {
                let day = event.agenda[selectedDayIndex].day
                agendaItems = getAgendaItems(day: day)
            }
        }
        .onChange(of: selectedDayIndex) { _, newIndex in
            guard event.agenda.indices.contains(newIndex) else { return }
            let day = event.agenda[newIndex].day
            agendaItems = getAgendaItems(day: day)
        }
    }

    @ViewBuilder
    private var eventTitleSection: some View {
        Text(event.name)
            .font(.novoNordiskCaption)
            .fontWeight(.bold)
            .foregroundColor(Color.novoNordiskTextGrey)
    }

    @ViewBuilder
    private var eventDaysSection: some View {
        EventAgendaTabSwitcher(selectedIndex: $selectedDayIndex, items: days)
    }

    @ViewBuilder
    private var eventAgendaSection: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ForEach(agendaItems.indices, id: \.self) { index in
                    let agendaItem = agendaItems[index]
                    EventAgendaItem(agendaItem: agendaItem, date: event.agenda[selectedDayIndex].date)
                }
            }
            .transition(.asymmetric(
                insertion: .opacity,
                removal: .opacity
            ))
            .animation(.easeInOut(duration: 0.4), value: agendaItems)
        }
    }

    private func getAgendaItems(day: Int) -> [ConferenceEventAgendaContent] {
        guard let firstAgendaDay = event.agenda.first(where: { $0.day == day }) else {
            return []
        }
        return firstAgendaDay.content
    }
}

#Preview("EventAgendaCardView") {

    let event = EventDetailsJsonMockGenerator.generateObject()

    VStack {
        if let event = event {
            EventAgendaCardView(event: event)
        } else {
            Text("Event not found")
        }
    }
}

#Preview("EventAgendaCardViewChm") {

    let event = EventDetailsJsonMockGenerator.generateObjectChM()

    VStack {
        if let event = event {
            EventAgendaCardView(event: event)
        } else {
            Text("Event not found")
        }
    }
}

