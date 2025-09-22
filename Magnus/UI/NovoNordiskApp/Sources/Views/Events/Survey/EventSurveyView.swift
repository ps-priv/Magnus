import SwiftUI
import MagnusFeatures

struct EventSurveyView: View {

    @StateObject private var viewModel: EventSurveyViewModel
    let eventId: String

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventSurveyViewModel(eventId: eventId))
    }

    var body: some View {
      
    }
}