//
//  SwiftUIView.swift
//  Sample App SwiftUI
//

import SwiftUI
import Didomi
import AppTrackingTransparency

struct ContentView: View {
    private let viewControllerRepresentable = ViewControllerRepresentable()
    private let adCoordinator = AdCoordinator()
    
    @State private var didomiEventListener: EventListener?
    @State private var webViewIsPresented = false
    
    private func showPreferences(_ view: Didomi.Views) {
        Didomi.shared.onReady {
            Didomi.shared.showPreferences(controller: viewControllerRepresentable.viewController, view: view)
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Button("Show Preferences") {
                showPreferences(.purposes)
            }
            Button("Show Preferences (Vendors)") {
                showPreferences(.vendors)
            }
            Button("Show Web View") {
                webViewIsPresented.toggle()
            }
            .sheet(isPresented: $webViewIsPresented) {
                WebView()
            }
            Button("Show Ad") {
                adCoordinator.presentAd(from: viewControllerRepresentable.viewController)
            }
        }
        .buttonStyle(DidomiButtonStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("pink-1"))
        .safeAreaInset(edge: .bottom) {
            Image("didomi_logo")
                .resizable()
                .frame(width: 128, height: 38)
        }
        .background {
            // Add the viewControllerRepresentable to the background so it
            // doesn't influence the placement of other views in the view hierarchy.
            viewControllerRepresentable
                .frame(width: .zero, height: .zero)
        }
        .onAppear() {
            if #unavailable(iOS 14) {
                // Show the Didomi CMP notice to collect consent from the user as iOS < 14 (no ATT available)
                Didomi.shared.setupUI(containerController: viewControllerRepresentable.viewController)
            }
            
            Didomi.shared.onReady {
                adCoordinator.loadAd()
            }
            
            // Remove any existing event listener
            if let eventListener = didomiEventListener {
                Didomi.shared.removeEventListener(listener: eventListener)
            }
            
            didomiEventListener = EventListener()
            didomiEventListener!.onConsentChanged = { event in
                // The consent status of the user has changed
                adCoordinator.loadAd()
            }
            
            Didomi.shared.addEventListener(listener: didomiEventListener!)
        }
        // We wait for the application to become active before calling requestTrackingAuthorization
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if #available(iOS 14, *) {
                // Here we show the Didomi notice after the ATT prompt whatever the ATT status.
                // You may want to do the following instead:
                // - Show the CMP notice then the ATT permission if the user gives consent in the CMP notice (https://developers.didomi.io/cmp/mobile-sdk/ios/app-tracking-transparency-ios-14#show-the-cmp-notice-then-the-att-permission-if-the-user-gives-consent-in-the-cmp-notice)
                // - Show the ATT permission then the CMP notice if the user accepts the ATT permission (https://developers.didomi.io/cmp/mobile-sdk/ios/app-tracking-transparency-ios-14#show-the-att-permission-then-the-cmp-notice-if-the-user-accepts-the-att-permission)
                ATTrackingManager.requestTrackingAuthorization { status in
                    // Show the Didomi CMP notice to collect consent from the user
                    print("ATT status = \(status)")
                    Didomi.shared.setupUI(containerController: viewControllerRepresentable.viewController)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
