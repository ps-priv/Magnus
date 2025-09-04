import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventAgendaView: View {

    @StateObject private var viewModel: EventAgendaViewModel

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventAgendaViewModel(eventId:eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if let event = viewModel.event {
                    EventAgendaCardView(event: event)
                } else {
                   EventDetailErrorMessageView(errorMessage: viewModel.errorMessage, errorTitle: LocalizedStrings.eventDetailsNotFoundTitle)
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}