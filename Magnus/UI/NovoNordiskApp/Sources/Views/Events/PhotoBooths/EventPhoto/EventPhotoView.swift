import Kingfisher
import MagnusDomain
import MagnusFeatures
import SwiftUI
import UIKit

struct EventPhotoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: EventPhotoViewModel
    var photoId: String
    var photoUrl: String
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var cachedImage: UIImage? = nil
    @State private var isSharing: Bool = false
    @State private var shareItems: [Any] = []
    @State private var showDeleteConfirmation: Bool = false

    init(photoId: String, photoUrl: String) {
        self.photoId = photoId
        self.photoUrl = photoUrl
        _viewModel = StateObject(wrappedValue: EventPhotoViewModel(photoId: photoId))
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
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

            Button(action: {
                navigationManager.goBack()
            }) {
                FAIcon(.close, type: .light, size: 18, color: .black)
                    .padding(15)
                    .background(Color.novoNordiskGrey.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(.top, 16)
            .padding(.trailing, 16)

            // Bottom action buttons
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    // Share button
                    Button(action: { shareImage() }) {
                        FAIcon(.share, type: .light, size: 18, color: .black)
                            .padding(18)
                            .background(Color.novoNordiskLightGrey)
                            .clipShape(Circle())
                    }

                    // Save button
                    Button(action: { saveImageToPhotos() }) {
                        FAIcon(.download, type: .light, size: 18, color: .black)
                            .padding(18)
                            .background(Color.novoNordiskLightGrey)
                            .clipShape(Circle())
                    }

                    // Delete button
                    Button(action: { showDeleteConfirmation = true }) {
                        FAIcon(.delete, type: .light, size: 18, color: .white)
                            .padding(18)
                            .background(Color.novoNordiskOrangeRed.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .sheet(isPresented: $isSharing) {
            ActivityView(activityItems: shareItems)
        }
        .novoNordiskAlert(
            isPresented: $showDeleteConfirmation,
            title: LocalizedStrings.eventPhotoDeleteConfirmationMessage,
            message: nil,
            icon: .delete,
            primaryTitle: LocalizedStrings.deleteButton,
            primaryStyle: .destructive,
            primaryAction: {
                deletePhoto()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    navigationManager.goBack()
                }
            },
            secondaryTitle: LocalizedStrings.cancelButton,
            secondaryStyle: .cancel,
            secondaryAction: {
                showDeleteConfirmation = false
            }
        )
    }
}

#if os(iOS)
    private struct ActivityView: UIViewControllerRepresentable {
        let activityItems: [Any]
        func makeUIViewController(context: Context) -> UIActivityViewController {
            UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        }
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context)
        {}
    }
#endif

extension EventPhotoView {
    fileprivate func fetchUIImage(completion: @escaping (UIImage?) -> Void) {
        if let cachedImage {
            completion(cachedImage)
            return
        }
        guard let url = URL(string: photoUrl) else {
            completion(nil)
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                cachedImage = value.image
                completion(value.image)
            case .failure:
                completion(nil)
            }
        }
    }

    fileprivate func saveImageToPhotos() {
        fetchUIImage { image in
            guard let image else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    fileprivate func shareImage() {
        fetchUIImage { image in
            if let image {
                shareItems = [image]
            } else if let url = URL(string: photoUrl) {
                shareItems = [url]
            } else {
                shareItems = []
            }
            if !shareItems.isEmpty { isSharing = true }
        }
    }

    func deletePhoto() {
        Task {
            await viewModel.deletePhoto()
        }
    }
}

#Preview("EventPhotoView") {
    VStack {
        EventPhotoView(
            photoId: "1",
            photoUrl: "https://nncv2-dev.serwik.pl/images/1_Gratulujemy_Zwyciezcom_CDC_Poland.jpg")
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
