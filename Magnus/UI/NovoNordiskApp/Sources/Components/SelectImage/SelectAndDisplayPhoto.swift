import Kingfisher
import PhotosUI
import SwiftUI
import UIKit
import ImageIO
import CoreImage
import UniformTypeIdentifiers

public struct SelectAndDisplayPhoto: View {
    @State private var onImageSelectedState: ((Data) -> Void)?

    @State private var pickerItem: PhotosPickerItem?
    @Binding private var imageData: Data?
    @State private var showUnsupportedAlert: Bool = false
    // Gestures state
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    // UI konfig
    private let cornerRadius: CGFloat = 12
    private let dash: [CGFloat] = [8, 6]

    public init(imageData: Binding<Data?>, onImageSelected: ((Data) -> Void)? = nil) {
        _onImageSelectedState = State(initialValue: onImageSelected)
        _imageData = imageData
    }

    public var body: some View {

        if let data = imageData {
            let provider = RawImageDataProvider(data: data, cacheKey: "picked-\(data.hashValue)")
            GeometryReader { geo in
                ZStack(alignment: .topTrailing) {
                    KFImage(source: .provider(provider))
                        .onFailure {  error in print("Image failed to load \(error)") }
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(scale)
                        .offset(offset)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius - 2))
                        .padding(8)
                        // Gestures: pan and pinch
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
                                }
                        )
                        .simultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let newScale = lastScale * value
                                    // Clamp between 1x and 4x
                                    scale = min(max(newScale, 1.0), 4.0)
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                }
                        )

                    Button {
                        imageData = nil
                        onImageSelectedState = nil
                        // Reset transforms when clearing the image
                        scale = 1.0
                        lastScale = 1.0
                        offset = .zero
                        lastOffset = .zero
                    } label: {
                        FAIcon(.delete, size: 16, color: Color.novoNordiskOrangeRed)
                            .frame(width: 25, height: 25)
                            .background(Circle().fill(Color.novoNordiskBackgroundGrey))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 18)
                    .padding(.trailing, 18)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
            }
            // Reset transforms when a new image is set
            .onChange(of: imageData) { _, _ in
                scale = 1.0
                lastScale = 1.0
                offset = .zero
                lastOffset = .zero
            }

        } else {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.novoNordiskBlue.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                Color.novoNordiskBlue, style: StrokeStyle(lineWidth: 2, dash: dash))
                    )

                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundColor(Color.novoNordiskBlue)
                    Text(LocalizedStrings.eventAddPhotoFromGalleryTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.novoNordiskBlue)
                }
                .accessibilityLabel(Text(LocalizedStrings.eventAddPhotoFromGalleryTitle))

                // Niewidoczny PhotosPicker jako overlay na całość
                PhotosPicker(
                    selection: $pickerItem,
                    matching: .images,
                    preferredItemEncoding: .compatible,
                    photoLibrary: .shared()
                ) {
                    Color.clear.contentShape(Rectangle())
                }
                .onChange(of: pickerItem) { _, newItem in
                    Task {
                        guard let item = newItem else { return }
                        // Load raw data, then normalize to JPEG/PNG using UIImage if possible (handles HEIC, etc.)
                        if let rawData = try? await item.loadTransferable(type: Data.self) {
                            // Allow only JPEG/PNG by inspecting the source UTI
                            if let src = CGImageSourceCreateWithData(rawData as CFData, nil),
                               let uti = CGImageSourceGetType(src) as String? {
                                let allowed = Set([UTType.jpeg.identifier, UTType.png.identifier])
                                if !allowed.contains(uti) {
                                    await MainActor.run {
                                        self.showUnsupportedAlert = true
                                        self.pickerItem = nil
                                    }
                                    return
                                }
                            }
                            let normalized = Self.normalizeImageData(rawData)
                            await MainActor.run {
                                self.imageData = normalized
                                self.onImageSelectedState?(normalized)
                            }
                        }
                    }
                }
                .allowsHitTesting(true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(LocalizedStrings.eventAddPhotoUnsupportedFormatMessage, isPresented: $showUnsupportedAlert) {
                Button(LocalizedStrings.ok, role: .cancel) {}
            } message: {
                Text(LocalizedStrings.eventAddPhotoUnsupportedFormatMessage)
            }
        }
    }
}

private extension SelectAndDisplayPhoto {
    static func normalizeImageData(_ data: Data) -> Data {
        // 1) Try via UIImage (fast path)
        if let uiImage = UIImage(data: data) {
            if let jpeg = uiImage.jpegData(compressionQuality: 0.9) { return jpeg }
            if let png = uiImage.pngData() { return png }
        }

        // 2) Try via CIImage + CGImage
        if let ciImage = CIImage(data: data) {
            let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
            if let cg = context.createCGImage(ciImage, from: ciImage.extent) {
                let ui = UIImage(cgImage: cg)
                if let jpeg = ui.jpegData(compressionQuality: 0.9) { return jpeg }
                if let png = ui.pngData() { return png }
            }
        }

        // 3) Try ImageIO decode and re-encode directly to JPEG (no UIImage dependency)
        let options: [CFString: Any] = [kCGImageSourceShouldCache: true]
        if let src = CGImageSourceCreateWithData(data as CFData, options as CFDictionary),
           let cg = CGImageSourceCreateImageAtIndex(src, 0, options as CFDictionary) {
            let destData = NSMutableData()
            if let dest = CGImageDestinationCreateWithData(destData, UTType.jpeg.identifier as CFString, 1, nil) {
                // Compression quality as kCGImageDestinationLossyCompressionQuality (0..1)
                let destProps: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: 0.9]
                CGImageDestinationAddImage(dest, cg, destProps as CFDictionary)
                if CGImageDestinationFinalize(dest) {
                    return destData as Data
                }
            }
        }

        // 4) Fallback to original data
        return data
    }
}

#Preview {
    VStack {
        SelectAndDisplayPhoto(imageData: .constant(nil), onImageSelected: {
            print("Image selected: \($0)")
        })
    }
    .padding(20)
}
