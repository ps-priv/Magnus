import MagnusApplication
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventMaterialsView: View {

    @StateObject private var viewModel: EventMaterialsViewModel

    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventMaterialsViewModel(eventId:eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if let event = viewModel.event {
                    EventMaterialsCardView(event: event)
                } else {
                   EventDetailErrorMessageView(errorMessage: viewModel.errorMessage, errorTitle: LocalizedStrings.eventDetailsNotFoundTitle)
                }
            }
        }
        .background(Color.novoNordiskBackgroundGrey)
    }
}