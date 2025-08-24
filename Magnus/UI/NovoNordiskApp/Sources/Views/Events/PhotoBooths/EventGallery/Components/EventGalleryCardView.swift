import SwiftUI
import MagnusDomain

struct EventGalleryCardView: View {
    @Binding public var gallery: [ConferenceEventPhotoBooth]

    let displayAction: () -> Void
    let deleteAction: () -> Void

    init(gallery: Binding<[ConferenceEventPhotoBooth]>, displayAction: @escaping () -> Void, deleteAction: @escaping () -> Void) {
        self._gallery = gallery
        self.displayAction = displayAction
        self.deleteAction = deleteAction
    }

    var body: some View {
        Text("Event Gallery")
    }
}
