import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MaterialPreview: View {
    private let remoteURL: URL?
    private let fileType: FileTypeEnum

    init(materialUrl: String, fileType: FileTypeEnum ) {
        self.remoteURL = MaterialPreview.parseURL(materialUrl)
        self.fileType = fileType
    }

    var body: some View {
        if let remoteURL {
            if fileType == .pdf {
                PDFView(fileURL: remoteURL)
            } else {
                WebView(fileURL: remoteURL)
            }
        } else {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                    .imageScale(.large)
                Text("Nieprawidłowy adres pliku")
                    .font(.novoNordiskBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    /// materialUrl comes from the API un-escaped, so file names with spaces or Polish
    /// diacritics fail `URL(string:)`; retry with percent-encoding before giving up.
    private static func parseURL(_ string: String) -> URL? {
        if let url = URL(string: string) {
            return url
        }
        return string
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            .flatMap(URL.init(string:))
    }
}