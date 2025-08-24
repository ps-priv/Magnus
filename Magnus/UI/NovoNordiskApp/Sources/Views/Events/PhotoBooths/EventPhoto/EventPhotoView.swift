import SwiftUI
import Kingfisher

struct EventPhotoView: View {
    var photoId: String
    var photoUrl: String

    init(photoId: String, photoUrl: String) {
        self.photoId = photoId
        self.photoUrl = photoUrl
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            KFImage(URL(string: photoUrl))
                .placeholder {
                    ProgressView()
                        .tint(.white)
                }
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFit()
                .background(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview("EventPhotoView") {
    VStack {
        EventPhotoView(photoId: "1", photoUrl: "https://nncv2-dev.serwik.pl/images/1_Gratulujemy_Zwyciezcom_CDC_Poland.jpg")
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

