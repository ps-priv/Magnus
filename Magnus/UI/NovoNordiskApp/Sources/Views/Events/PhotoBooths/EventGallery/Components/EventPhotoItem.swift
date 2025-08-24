import SwiftUI
import MagnusDomain
import Kingfisher

struct EventPhotoItem: View {
    var photo: ConferenceEventPhotoBooth
    let size: CGFloat

    let deleteAction: () -> Void

    init(photo: ConferenceEventPhotoBooth, size: CGFloat = 120, deleteAction: @escaping () -> Void) {
        self.photo = photo
        self.size = size
        self.deleteAction = deleteAction
    }

    var body: some View {
        ZStack {
            // Square white background
            Rectangle()
                .fill(Color.white)

            // Image with padding inside the square
            KFImage(URL(string: photo.image))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(ProgressView().tint(.gray))
                }
                .cancelOnDisappear(true)
                .resizable()
                .clipped()
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack {
        EventPhotoItem(photo: ConferenceEventPhotoBooth(id: "1", image: "https://nncv2-dev.serwik.pl/images/1_Gratulujemy_Zwyciezcom_CDC_Poland.jpg"), size: 300, deleteAction: {})
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}


