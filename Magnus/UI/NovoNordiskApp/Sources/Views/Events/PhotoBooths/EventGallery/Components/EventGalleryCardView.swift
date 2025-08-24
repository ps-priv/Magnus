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

            VStack(alignment: .leading) {
                galleryTitle
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
                .padding(.horizontal, 10)
                .padding(.top, 0)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    private var galleryTitle: some View {
        HStack {
            HStack {
                FAIcon(.image, type: .regular, size: 20, color: Color.novoNordiskBlue)
                Text(LocalizedStrings.eventPhotoScreenTitle)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Spacer()
        }
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }
}

#Preview("EventGalleryCardView") {
    let items: [ConferenceEventPhotoBooth] = (1...37).map { i in
        ConferenceEventPhotoBooth(id: "\(i)", image: "https://nncv2-dev.serwik.pl/images/1_Gratulujemy_Zwyciezcom_CDC_Poland.jpg")
    }
    VStack {
        EventGalleryCardView(gallery: .constant(items), displayAction: {}, deleteAction: {})
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
