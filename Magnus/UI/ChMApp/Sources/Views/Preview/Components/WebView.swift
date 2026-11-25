import SwiftUI
import WebKit

struct WebView: View {
    let fileURL: URL
   
    var body: some View {
        WKWebViewContainer(url: fileURL)
            .ignoresSafeArea()
    }
}

// MARK: - WKWebView container (cross-platform)
private struct WKWebViewContainer {
    let url: URL
}

#if canImport(UIKit)
extension WKWebViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
}
#elseif canImport(AppKit)
extension WKWebViewContainer: NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if nsView.url != url {
            nsView.load(URLRequest(url: url))
        }
    }
}
#endif