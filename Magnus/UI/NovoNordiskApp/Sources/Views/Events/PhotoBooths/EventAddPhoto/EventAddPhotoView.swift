import SwiftUI
import MagnusDomain
import MagnusFeatures
import UIKit

struct EventAddPhotoView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    var eventId: String
    @State private var imageData: Data? = nil
    @State private var isUploading: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var showCamera: Bool = false

    init(eventId: String) {
        self.eventId = eventId
    }

#if os(iOS)
private struct CameraPicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var selected: UIImage?
            if let edited = info[.editedImage] as? UIImage {
                selected = edited
            } else if let original = info[.originalImage] as? UIImage {
                selected = original
            }

            if let image = selected {
                // Prefer JPEG with reasonable quality
                if let data = image.jpegData(compressionQuality: 0.9) {
                    parent.imageData = data
                } else if let data = image.pngData() {
                    parent.imageData = data
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
#endif

    var body: some View {
        VStack(spacing: 20) {
            
            SelectAndDisplayPhoto(imageData: $imageData) { data in
                imageData = data
            }

            Spacer()

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button(action: { showCamera = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "camera")
                        Text(LocalizedStrings.eventAddPhotoTakePhotoButtonTitle)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.novoNordiskLightGrey)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
            }

            Button(action: { upload() }) {
                HStack {
                    if isUploading { ProgressView().tint(.white) }
                    Text(LocalizedStrings.eventAddPhotoUploadButtonTitle)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background((imageData == nil || isUploading) ? Color.novoNordiskLightGrey : Color.novoNordiskBlue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(imageData == nil || isUploading)
        }
        .padding()
        .toast(isPresented: $showToast, message: toastMessage)
        .sheet(isPresented: $showCamera) {
            CameraPicker(imageData: $imageData)
                .ignoresSafeArea()
        }
    }

    private func upload() {
        guard let data = imageData else { return }
        isUploading = true
        toastMessage = ""
        Task<Void, Never> {
            do {
                if let service: ApiEventsService = DIContainer.shared.resolve(ApiEventsService.self) {
                    try await service.uploadEventPhoto(eventId: eventId, image: data)
                    toastMessage = LocalizedStrings.eventAddPhotoAddedMessage
                    showToast = true
                    // navigate back after short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        navigationManager.goBack()
                    }
                } else {
                    throw NSError(domain: "EventAddPhotoView", code: -2, userInfo: [NSLocalizedDescriptionKey: "Brak serwisu uploadu"]) 
                }
            } catch {
                toastMessage = error.localizedDescription
                showToast = true
            }
            isUploading = false
        }
    }
}

#Preview {
    VStack {
        EventAddPhotoView(eventId: "123")
    }
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
