import SwiftUI
import MagnusFeatures

struct EventGalleryView: View {
    let eventId: String
    @StateObject private var viewModel: EventGalleryViewModel

    init(eventId: String) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventGalleryViewModel(eventId: eventId))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if viewModel.gallery != nil {
                    EventGalleryCardView(
                        gallery: Binding(
                            get: { viewModel.gallery ?? [] },
                            set: { viewModel.gallery = $0 }
                        ),
                        displayAction: {},
                        deleteAction: {}
                    )
                }
                else {
                    EventPhotosNotFound()
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color.novoNordiskBackgroundGrey)

    }
}
