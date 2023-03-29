//
//  WebView.swift
//  Sample App SwiftUI
//

import SwiftUI
import WebKit
import Didomi

struct WebView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // The notice should automatically get hidden in the web view as consent is passed from the mobile app to the website. However, it might happen that the notice gets displayed for a very short time before being hidden. You can disable the notice in your web view to make sure that it never shows by appending didomiConfig.notice.enable=false to the query string of the URL that you are loading
        let url = URL(string:"https://didomi.github.io/webpage-for-sample-app-webview/?didomiConfig.notice.enable=false")!
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Inject consent information into the web view
        Didomi.shared.onReady {
            let string = Didomi.shared.getJavaScriptForWebView()
            let script = WKUserScript(source: string, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(script)
        }
    }
}
