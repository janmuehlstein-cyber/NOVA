import SwiftUI
import WebKit
import UIKit

struct CalendarWebView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let content = WKUserContentController()
        content.add(context.coordinator, name: "novaCalendar")

        let config = WKWebViewConfiguration()
        config.userContentController = content
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isOpaque = false
        webView.backgroundColor = UIColor.systemBackground
        webView.load(URLRequest(url: URL(string: "https://janmuehlstein-cyber.github.io/NOVA/")!))
        context.coordinator.webView = webView
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        weak var webView: WKWebView?
        private let calendar = AppleCalendarService()

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            guard webView.url?.host == "janmuehlstein-cyber.github.io" else { return }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
            if url.host == "janmuehlstein-cyber.github.io" || url.host == "github.com" {
                decisionHandler(.allow)
            } else if navigationAction.navigationType == .linkActivated {
                decisionHandler(.cancel)
                UIApplication.shared.open(url)
            } else {
                decisionHandler(.cancel)
            }
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "novaCalendar",
                  let body = message.body as? [String: Any],
                  let requestID = body["id"] as? String,
                  let action = body["action"] as? String,
                  let payload = body["payload"] as? [String: Any] else { return }

            Task { @MainActor in
                do {
                    let data = try await calendar.perform(action: action, payload: payload)
                    send(requestID: requestID, result: ["ok": true, "data": data])
                } catch {
                    send(requestID: requestID, result: ["ok": false, "error": error.localizedDescription])
                }
            }
        }

        @MainActor private func send(requestID: String, result: [String: Any]) {
            guard let webView,
                  let data = try? JSONSerialization.data(withJSONObject: result),
                  let json = String(data: data, encoding: .utf8),
                  let safeID = try? JSONSerialization.data(withJSONObject: requestID),
                  let idLiteral = String(data: safeID, encoding: .utf8) else { return }
            webView.evaluateJavaScript("window.NOVACalendarBridge && window.NOVACalendarBridge.resolve(\(idLiteral), \(json));")
        }
    }
}
