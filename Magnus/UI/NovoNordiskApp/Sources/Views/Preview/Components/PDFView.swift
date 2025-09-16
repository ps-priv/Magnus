import PDFKit
import SwiftUI

struct PDFView: View {
    let fileURL: URL
   
    var body: some View {
        PDFContentView(fileURL: fileURL)
            .ignoresSafeArea()
    }
}

// MARK: - Internal Content View handling loading/downloading
private struct PDFContentView: View {
    let fileURL: URL
    @State private var document: PDFDocument?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let document {
                PDFKitContainer(document: document)
            } else if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading PDF…")
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                        .imageScale(.large)
                    Text("Failed to load PDF")
                        .font(.novoNordiskBody)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Color.clear
                    .task {
                        await load()
                    }
            }
        }
        .background(Color.clear)
        .onAppear {
            if document == nil && !isLoading {
                Task { await load() }
            }
        }
    }

    @MainActor
    private func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            if fileURL.isFileURL {
                if let doc = PDFDocument(url: fileURL) {
                    self.document = doc
                } else {
                    throw NSError(domain: "PDFView", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid PDF file"])
                }
            } else {
                let (data, _) = try await URLSession.shared.data(from: fileURL)
                guard let doc = PDFDocument(data: data) else {
                    throw NSError(domain: "PDFView", code: -2, userInfo: [NSLocalizedDescriptionKey: "Downloaded data is not a valid PDF"])
                }
                self.document = doc
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

// MARK: - PDFKit container (cross-platform)
private struct PDFKitContainer {
    let document: PDFDocument
}

#if canImport(UIKit)
extension PDFKitContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .clear
        pdfView.document = document
        return pdfView
    }

    func updateUIView(_ uiView: PDFKit.PDFView, context: Context) {
        if uiView.document != document {
            uiView.document = document
        }
    }
}
#elseif canImport(AppKit)
extension PDFKitContainer: NSViewRepresentable {
    func makeNSView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.backgroundColor = .clear
        pdfView.document = document
        return pdfView
    }

    func updateNSView(_ nsView: PDFKit.PDFView, context: Context) {
        if nsView.document != document {
            nsView.document = document
        }
    }
}
#endif