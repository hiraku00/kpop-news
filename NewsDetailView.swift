import SwiftUI
import WebKit // WKWebView を利用するために必要 (SwiftUI.WebView は内部で WKWebView を使用)

struct NewsDetailView: View {
    let url: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        if #available(iOS 16.0, *) {
            WebViewContainer(url: URL(string: url)!)
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitleDisplayMode(.inline)
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.width > 100 {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                )
        } else {
            Text("この機能は iOS 16.0 以降でのみ利用可能です。")
        }
    }
}

@available(iOS 16.0, *)
struct WebViewContainer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
