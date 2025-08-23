import Kingfisher
import PhotosUI
import SwiftUI

public struct SelectAndDisplayImage: View {
    @State private var onImageSelectedState: ((Data) -> Void)?

    @State private var pickerItem: PhotosPickerItem?
    @State private var imageData: Data?

    // UI konfig
    private let height: CGFloat = 180
    private let cornerRadius: CGFloat = 12
    private let dash: [CGFloat] = [8, 6]

    public init(onImageSelected: ((Data) -> Void)? = nil) {
        _onImageSelectedState = State(initialValue: onImageSelected)
    }

    public var body: some View {

        if let data = imageData {
            let provider = RawImageDataProvider(data: data, cacheKey: "picked-\(data.hashValue)")
            ZStack(alignment: .topTrailing) {
                KFImage(source: .provider(provider))
                    .onFailure { _ in /* opcjonalnie pokaż błąd */ }
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: height - 16)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius - 2))
                    .padding(8)

                Button {
                    imageData = nil
                    onImageSelectedState = nil
                } label: {
                    FAIcon(.delete, size: 16, color: Color.novoNordiskOrangeRed)
                        .background(Circle().fill(Color.novoNordiskBackgroundGrey))
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(10)
            }

        } else {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemTeal).opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                Color(.systemTeal), style: StrokeStyle(lineWidth: 2, dash: dash))
                    )

                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundColor(Color(.systemTeal))
                    Text("Dodaj obrazek.")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.systemTeal))
                }
                .accessibilityLabel(Text("Dodaj obrazek"))

                // Niewidoczny PhotosPicker jako overlay na całość
                PhotosPicker(
                    selection: $pickerItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Color.clear.contentShape(Rectangle())
                }
                .onChange(of: pickerItem) { newItem in
                    Task {
                        guard let item = newItem else { return }
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            await MainActor.run {
                                self.imageData = data
                                self.onImageSelectedState?(data)
                            }
                        }
                    }
                }
                .allowsHitTesting(true)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
        }
    }
}

#Preview {
    VStack {
        SelectAndDisplayImage(onImageSelected: {
            print("Image selected: \($0)")
        })
    }
    .padding(20)
}
