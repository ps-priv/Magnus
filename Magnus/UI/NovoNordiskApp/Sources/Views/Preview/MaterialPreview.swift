import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MaterialPreview: View {
    private let remoteURL: URL?
    private let fileType: FileTypeEnum

    init(materialUrl: String, fileType: FileTypeEnum ) {
        self.remoteURL = URL(string: materialUrl)
        self.fileType = fileType
    }
    
    var body: some View {
        if fileType == .pdf {
            PDFView(fileURL: remoteURL ?? URL(fileURLWithPath: ""))
        } else {
            WebView(fileURL: remoteURL ?? URL(fileURLWithPath: ""))
        }
    }
}