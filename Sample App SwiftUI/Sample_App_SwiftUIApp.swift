//
//  Sample_App_SwiftUIApp.swift
//  Sample App SwiftUI
//

import SwiftUI
import Didomi
import GoogleMobileAds


// Create a new class that extends the UIApplicationDelegate protocol.
// Inside the applicationDidFinishLaunchingWithOptions method, call the Didomi initialize method.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var didomiEventListener: EventListener?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let parameters = DidomiInitializeParameters(
            apiKey: "7dd8ec4e-746c-455e-a610-99121b4148df", // Replace with your API key
            localConfigurationPath: nil,
            remoteConfigurationURL: nil,
            providerID: nil,
            disableDidomiRemoteConfig: false,
            noticeID: "DVLP9Qtd" // Replace with your notice ID, or remove if using domain targeting
        )
        
        // Initialize the SDK
        Didomi.shared.initialize(parameters)
        
        // Important: views should not wait for onReady to be called.
        // You might want to execute code here that needs the Didomi SDK
        // to be initialized such as: analytics and other non-IAB vendors.
        Didomi.shared.onReady {
            // The Didomi SDK is ready to go, you can call other functions on the SDK
            [weak self] in
            
            // Load your custom vendors in the onReady callback.
            // These vendors need to be conditioned manually to the consent status of the user.
            self?.loadVendor()
        }
        
        // Load the IAB vendors; the consent status will be shared automatically with them.
        // Regarding the Google Mobile Ads SDK, we also delay App Measurement as described here:
        // https://developers.google.com/admob/ios/eu-consent#delay_app_measurement_optional
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    func loadVendor() {
        
        let vendorId = "c:customven-gPVkJxXD"
        let didomi = Didomi.shared
        let status = didomi.getUserStatus()
        let isVendorEnabled = status.vendors.global.enabled.contains(vendorId)
        
        // Remove any existing event listener
        if let eventListener = didomiEventListener {
            didomi.removeEventListener(listener: eventListener)
        }
        
        if (isVendorEnabled) {
            // We have consent for the vendor
            // Initialize the vendor SDK
            CustomVendor.shared.initialize()
        } else {
            // We do not have consent information yet
            // Wait until we get the user information
            didomiEventListener = EventListener()
            didomiEventListener!.onConsentChanged = { [weak self] event in
                self?.loadVendor()
            }
            didomi.addEventListener(listener: didomiEventListener!)
        }
    }
}

// Use the UIApplicationDelegateAdaptor property wrapper inside your App declaration to tell SwiftUI about the delegate type:
@main
struct Sample_App_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
