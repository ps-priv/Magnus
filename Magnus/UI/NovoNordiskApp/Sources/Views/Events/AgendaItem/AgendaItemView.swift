import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct AgendaItemView: View {

    @StateObject private var viewModel: EventAgendaItemViewModel
    @EnvironmentObject private var navigationManager: NavigationManager

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventAgendaItemViewModel(eventId:eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                let agendaItem = viewModel.agenda
                let location = viewModel.location

                if let event = agendaItem, let location = location {
                    AgendaItemCardView(agendaItem: event, location: location, action: navigateToAgenda, date: "")
                } else {
                   EventDetailErrorMessageView(errorMessage: viewModel.errorMessage, errorTitle: LocalizedStrings.eventDetailsNotFoundTitle)
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }

    private func navigateToAgenda() {
        navigationManager.goBack()
    }
}