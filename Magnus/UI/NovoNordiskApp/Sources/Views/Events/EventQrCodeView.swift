import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventQrCodeView: View {
    let eventId: String
    @State private var event: ConferenceEvent?
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(alignment: .center) {
            Text(event?.title ?? "")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 24)
 
            Text(LocalizedStrings.eventQrCodeScanToRegister)
                .multilineTextAlignment(.center)
            Spacer()
            if let event = event, let qrImage = generateQRCode(from: generateQRCodeText(event: event)) {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
            }

            Spacer()
            NovoNordiskButton(
                title: LocalizedStrings.buttonClose,
                style: .primary
            ) {
                navigationManager.navigate(to: .eventsList)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
        .onAppear {
            loadEvent()
        }
    }

    private func loadEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            event = EventMockGenerator.createSingle()
        }
    }

    private func generateQRCodeText(event: ConferenceEvent?) -> String {
        guard let event = event else {
            return "Domyslne wydarzenie"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let currentDateTime: String = dateFormatter.string(from: Date())

        return "\(event.title)\n\(currentDateTime)"
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            // Scale up the QR code for better quality
            let scaleX = 250 / outputImage.extent.size.width
            let scaleY = 250 / outputImage.extent.size.height
            let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

            if let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return nil
    }
}

#Preview("EventQrCodeView") {
    EventQrCodeView(eventId: "1")
        .environmentObject(NavigationManager())
}
