import SwiftUI
import MagnusDomain

struct EventGalleryCardView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    @Binding public var gallery: [ConferenceEventPhotoBooth]

    let deleteAction: () -> Void
    let eventId: String

    init(gallery: Binding<[ConferenceEventPhotoBooth]>, deleteAction: @escaping () -> Void, eventId: String) {
        self._gallery = gallery
        self.deleteAction = deleteAction
        self.eventId = eventId
    }

    var body: some View {

            ZStack(alignment: .bottomTrailing) {
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
                                    EventPhotoItem(photo: photo, size: itemSize, deleteAction: deleteAction, displayAction: {
                                        navigationManager.navigateToEventPhoto(photoId: photo.id, photoUrl: photo.image)
                                    })
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

                // Add button in bottom-right corner
                Button(action: {
                    navigationManager.navigateToEventAddPhoto(eventId: eventId)
                }) {
                    FAIcon(.plus, type: .solid, size: 18, color: .white)
                        .frame(width: 52, height: 52)
                        .background(Circle().fill(Color.novoNordiskLightBlue))
                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .padding(16)
                .accessibilityLabel(LocalizedStringKey(LocalizedStrings.eventAddPhotoScreenTitle))
            }
    }

    @ViewBuilder
    private var galleryTitle: some View {
        HStack {
            HStack {
                FAIcon(.image, type: .regular, size: 20, color: Color.novoNordiskTextGrey)
                Text(LocalizedStrings.eventPhotoScreenTitle)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
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
        EventGalleryCardView(gallery: .constant(items), deleteAction: {}, eventId: "123")
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}


