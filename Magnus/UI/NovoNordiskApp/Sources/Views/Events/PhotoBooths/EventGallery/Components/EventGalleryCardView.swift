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
        GeometryReader { geometry in
            // Layout constants
            let columnsCount: CGFloat = 3
            let spacing: CGFloat = 3
            let horizontalPadding: CGFloat = 0
            let totalSpacing = spacing * (columnsCount - 1)
            let contentWidth = geometry.size.width - (horizontalPadding * 2)
            let itemSize = (contentWidth - totalSpacing) / columnsCount

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: Int(columnsCount)), spacing: spacing) {
                    ForEach(gallery) { photo in
                        EventPhotoItem(photo: photo, size: itemSize) {
                            // Forward delete action for the item
                            deleteAction()
                        }
                        .onTapGesture { displayAction() }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview("EventGalleryCardView") {
    let items: [ConferenceEventPhotoBooth] = (1...17).map { i in
        ConferenceEventPhotoBooth(id: "\(i)", image: "https://nncv2-dev.serwik.pl/images/1_Gratulujemy_Zwyciezcom_CDC_Poland.jpg")
    }
    VStack {
        EventGalleryCardView(gallery: .constant(items), displayAction: {}, deleteAction: {})
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}