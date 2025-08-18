import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventDinnerView: View {

    @StateObject private var viewModel: EventDinnerViewModel

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventDinnerViewModel(eventId:eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if let event = viewModel.event {
                    EventDinnerCardView(dinner: event.dinner, event_name: event.name)
                } else {
                   EventDetailErrorMessageView(errorMessage: viewModel.errorMessage, errorTitle: LocalizedStrings.eventDetailsNotFoundTitle)
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}