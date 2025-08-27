import SwiftUI
import Kingfisher

struct EventPhotoView: View {
    var photoId: String
    var photoUrl: String
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

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
                .scaleEffect(scale)
                .offset(offset)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                            if scale <= 1.0 {
                                withAnimation(.spring()) {
                                    scale = 1.0
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                        }
                )
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScale
                            var newScale = scale * delta
                            newScale = min(max(newScale, 1.0), 5.0)
                            scale = newScale
                            lastScale = value
                        }
                        .onEnded { _ in
                            lastScale = 1.0
                            if scale <= 1.0 {
                                withAnimation(.spring()) {
                                    scale = 1.0
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                        }
                )
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


